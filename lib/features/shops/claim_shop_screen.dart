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

  Future<void> _checkGps() async {
    setState(() { _error = null; _loading = true; });

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() { _error = 'Activa el GPS de tu dispositivo.'; _loading = false; return; });
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() { _error = 'Permiso de ubicación denegado.'; _loading = false; return; });
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() { _error = 'Activa los permisos de ubicación en ajustes.'; _loading = false; return; });
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      final distance = Geolocator.distanceBetween(
        position.latitude, position.longitude,
        widget.shop.location.latitude, widget.shop.location.longitude,
      );

      if (distance > 20) {
        setState(() {
          _error = 'Estás a ${distance.toInt()}m del local. Máximo 20m permitido.';
          _loading = false;
        });
        return;
      }

      final fs = context.read<FirestoreService>();
      final auth = context.read<AuthProvider>();
      final alreadyPending = await fs.hasPendingClaim(widget.shop.id, auth.user!.uid);
      if (alreadyPending) {
        setState(() {
          _error = 'Ya tienes una solicitud pendiente de revisión.';
          _loading = false;
        });
        return;
      }

      if (widget.shop.verifiedOwnerUid != null) {
        setState(() {
          _error = 'Esta cafetería ya tiene un dueño verificado.';
          _loading = false;
        });
        return;
      }

      setState(() { _step = 1; _loading = false; });
    } catch (_) {
      setState(() { _error = 'Error al obtener ubicación. Intenta de nuevo.'; _loading = false; });
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
      setState(() => _error = 'Sube mínimo 1 documento que acredite tu propiedad.');
      return;
    }
    if (_selfies.isEmpty) {
      setState(() => _error = 'Sube mínimo 1 selfie dentro del establecimiento.');
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
      userId: auth.user!.uid, userName: auth.user?.displayName ?? 'Usuario',
      userEmail: auth.user?.email ?? '', documentPhotos: docUrls, selfiePhotos: selfieUrls,
      status: 'pending', createdAt: DateTime.now(),
    ));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitud enviada. Revisaremos tus documentos pronto.'),
          backgroundColor: AppColors.secondary, duration: Duration(seconds: 5),
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
        appBar: AppBar(title: const Text('Dueño')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, size: 64, color: AppColors.secondary),
              const SizedBox(height: 16),
              Text(shop.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Esta cafetería ya tiene un dueño verificado.',
                  style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Acreditar como Dueño')),
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
        const Text('Paso 1 de 2: Verificación GPS',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Debes estar a 20 metros o menos del local.',
            style: TextStyle(color: AppColors.textSecondary)),
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
            label: const Text('Verificar mi ubicación'),
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
        const Text('Paso 2 de 2: Documentos y Selfie',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Sube documentos que acrediten tu propiedad y una selfie en el local.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        const SizedBox(height: 20),

        _photoSection(
          title: 'Documentos de propiedad',
          subtitle: 'Recibos de luz, agua, renta (mín. 1, máx. 2)',
          photos: _documents,
          maxPhotos: 2,
          isDocument: true,
        ),
        const SizedBox(height: 20),
        _photoSection(
          title: 'Selfie en el establecimiento',
          subtitle: 'Con uniforme del local si es posible (mín. 1, máx. 2)',
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
          child: const Row(
            children: [
              Icon(Icons.shield_outlined, color: AppColors.star, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'La dirección del documento debe coincidir con la cafetería. Revisaremos tu caso en 24-48h.',
                  style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
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
            label: const Text('Enviar solicitud'),
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
