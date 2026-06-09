import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/firestore_service.dart';
import '../../../services/storage_service.dart';
import '../../../models/coffee_shop.dart';
import '../../../models/owner_claim.dart';
import '../../../l10n/app_localizations.dart';

class ClaimShopScreen extends StatefulWidget {
  final CoffeeShop shop;
  const ClaimShopScreen({super.key, required this.shop});

  @override
  State<ClaimShopScreen> createState() => _ClaimShopScreenState();
}

class _ClaimShopScreenState extends State<ClaimShopScreen> {
  int _step = 0;
  bool _loading = false;
  String? _error;
  final List<Uint8List> _documents = [];
  final List<Uint8List> _selfies = [];

  AppLocalizations get l10n => AppLocalizations.of(context);

  Future<void> _checkGps() async {
    setState(() { _error = null; _loading = true; });

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() { _error = l10n.gpsNotEnabled; _loading = false; return; });
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() { _error = l10n.gpsPermissionDenied; _loading = false; return; });
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() { _error = l10n.gpsPermissionPermanent; _loading = false; return; });
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      final distance = Geolocator.distanceBetween(
        position.latitude, position.longitude,
        widget.shop.location.latitude, widget.shop.location.longitude,
      );

      if (distance > 20) {
        setState(() {
          _error = l10n.tooFar(distance.toInt().toString());
          _loading = false;
        });
        return;
      }

      final fs = context.read<FirestoreService>();
      final auth = context.read<AuthProvider>();
      final alreadyPending = await fs.hasPendingClaim(widget.shop.id, auth.user!.uid);
      if (alreadyPending) {
        setState(() {
          _error = l10n.alreadyClaimPending;
          _loading = false;
        });
        return;
      }

      if (widget.shop.verifiedOwnerUid != null) {
        setState(() {
          _error = l10n.shopHasOwner;
          _loading = false;
        });
        return;
      }

      setState(() { _step = 1; _loading = false; });
    } catch (_) {
      setState(() { _error = l10n.locationError; _loading = false; });
    }
  }

  Future<void> _pickPhoto(bool isDocument) async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() {
        if (isDocument) { _documents.add(bytes); } else { _selfies.add(bytes); }
      });
    }
  }

  Future<void> _submitClaim() async {
    if (_documents.isEmpty) {
      setState(() => _error = l10n.docsDesc);
      return;
    }
    if (_selfies.isEmpty) {
      setState(() => _error = l10n.selfieDesc);
      return;
    }

    setState(() { _loading = true; _error = null; });

    final auth = context.read<AuthProvider>();
    final fs = context.read<FirestoreService>();
    final storage = context.read<StorageService>();
    final shop = widget.shop;

    final docUrls = <String>[];
    for (final bytes in _documents) {
      docUrls.add(await storage.uploadImageBytes(bytes, name: 'doc_${shop.id}'));
    }

    final selfieUrls = <String>[];
    for (final bytes in _selfies) {
      selfieUrls.add(await storage.uploadImageBytes(bytes, name: 'selfie_${shop.id}'));
    }

    await fs.submitOwnerClaim(OwnerClaim(
      id: '', shopId: shop.id, shopName: shop.name, shopAddress: shop.address,
      userId: auth.user!.uid, userName: auth.user?.displayName ?? l10n.user,
      userEmail: auth.user?.email ?? '', documentPhotos: docUrls, selfiePhotos: selfieUrls,
      status: 'pending', createdAt: DateTime.now(),
    ));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.claimSubmitted),
          backgroundColor: AppColors.secondary, duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = widget.shop;
    final hasOwner = shop.verifiedOwnerUid != null;

    if (hasOwner) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.ownerVerified)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, size: 64, color: AppColors.secondary),
              const SizedBox(height: 16),
              Text(shop.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(l10n.hasOwnerMessage,
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.goBack),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.claimOwner)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _step == 0 ? _gpsStep(shop) : _docsStep(shop),
      ),
    );
  }

  Widget _gpsStep(CoffeeShop shop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.gpsStep1,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(l10n.gpsDesc,
            style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface, borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.store, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(shop.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.location_on, color: AppColors.secondary, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(shop.address)),
              ]),
            ],
          ),
        ),
        const Spacer(),
        if (_error != null)
          Container(
            padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8),
            ),
            child: Text(_error!, style: const TextStyle(color: AppColors.error)),
          ),
        SizedBox(
          width: double.infinity, height: 52,
          child: ElevatedButton.icon(
            onPressed: _loading ? null : _checkGps,
            icon: _loading
                ? const SizedBox(width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.gps_fixed),
            label: Text(l10n.verifyLocation),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _docsStep(CoffeeShop shop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.docsStep2,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(l10n.docsSubtitle,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        const SizedBox(height: 20),

        _photoSection(
          title: l10n.propertyDocs,
          subtitle: l10n.docsDesc,
          photos: _documents,
          maxPhotos: 2,
          isDocument: true,
        ),
        const SizedBox(height: 20),
        _photoSection(
          title: l10n.selfie,
          subtitle: l10n.selfieDesc,
          photos: _selfies,
          maxPhotos: 2,
          isDocument: false,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.star.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.shield_outlined, color: AppColors.star, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.docsPolicy,
                  style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        if (_error != null)
          Container(
            padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8),
            ),
            child: Text(_error!, style: const TextStyle(color: AppColors.error)),
          ),
        SizedBox(
          width: double.infinity, height: 52,
          child: ElevatedButton.icon(
            onPressed: _loading ? null : _submitClaim,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
            icon: _loading
                ? const SizedBox(width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.verified),
            label: Text(l10n.submitClaim),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _photoSection({
    required String title,
    required String subtitle,
    required List<Uint8List> photos,
    required int maxPhotos,
    required bool isDocument,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: [
            ...photos.map((bytes) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(bytes, width: 90, height: 90, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 0, top: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: AppColors.error, size: 18),
                        onPressed: () => setState(() => photos.remove(bytes)),
                      ),
                    ),
                  ],
                )),
            if (photos.length < maxPhotos)
              GestureDetector(
                onTap: () => _pickPhoto(isDocument),
                child: Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.background,
                  ),
                  child: const Icon(Icons.add, color: AppColors.textSecondary),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
