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
  Uint8List? _documentBytes;
  String _statusMessage = '';

  Future<void> _checkGps() async {
    setState(() { _error = null; _loading = true; });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() { _error = 'Activa el GPS de tu dispositivo.'; _loading = false; });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() { _error = 'Permiso de ubicación denegado.'; _loading = false; });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() { _error = 'Activa los permisos de ubicación en ajustes.'; _loading = false; });
      return;
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
          _statusMessage = 'Ya tienes una solicitud pendiente de revisión.';
          _loading = false;
        });
        return;
      }

      setState(() { _step = 1; _loading = false; });
    } catch (e) {
      setState(() { _error = 'Error al obtener ubicación. Intenta de nuevo.'; _loading = false; });
    }
  }

  Future<void> _pickDocument() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() => _documentBytes = bytes);
    }
  }

  Future<void> _submitClaim() async {
    if (_documentBytes == null) {
      setState(() => _error = 'Sube una foto del documento que acredite tu propiedad.');
      return;
    }

    setState(() { _loading = true; _error = null; });

    final auth = context.read<AuthProvider>();
    final fs = context.read<FirestoreService>();
    final storage = context.read<StorageService>();
    final shop = widget.shop;

    final documentUrl = await storage.uploadImageBytes(
      _documentBytes!,
      name: 'owner_doc_${shop.id}_${auth.user!.uid}',
    );

    await fs.submitOwnerClaim(OwnerClaim(
      id: '',
      shopId: shop.id,
      shopName: shop.name,
      shopAddress: shop.address,
      userId: auth.user!.uid,
      userName: auth.user?.displayName ?? 'Usuario',
      userEmail: auth.user?.email ?? '',
      documentPhotoUrl: documentUrl,
      status: 'pending',
      createdAt: DateTime.now(),
    ));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitud enviada. Un administrador la revisará pronto.'),
          backgroundColor: AppColors.secondary,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acreditar como Dueño')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _step == 0 ? _buildGpsStep() : _buildDocumentStep(),
      ),
    );
  }

  Widget _buildGpsStep() {
    final shop = widget.shop;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Paso 1 de 2: Verificación GPS',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text(
          'Debes estar físicamente en el local (máximo 20 metros).',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
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
                const Icon(Icons.store, color: AppColors.primary, size: 20),
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
        if (_statusMessage.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.star.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
              const Icon(Icons.info_outline, color: AppColors.star, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(_statusMessage)),
            ]),
          ),
        ],
        const Spacer(),
        if (_error != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
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

  Widget _buildDocumentStep() {
    final shop = widget.shop;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Paso 2 de 2: Documento de propiedad',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text(
          'Sube una foto de un recibo de luz, agua, renta o documento oficial que muestre la dirección del local.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface, borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(shop.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(shop.address,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (_documentBytes != null)
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(_documentBytes!, width: double.infinity, height: 200, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => setState(() => _documentBytes = null),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Cambiar foto'),
              ),
            ],
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider, width: 2),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.background,
            ),
            child: Column(
              children: [
                const Icon(Icons.description_outlined, size: 48, color: AppColors.tertiary),
                const SizedBox(height: 12),
                const Text('Recibo de luz, agua o renta',
                    style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _pickDocument,
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Tomar foto o subir'),
                  style: OutlinedButton.styleFrom(minimumSize: Size.zero),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.star.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.shield_outlined, color: AppColors.star, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'La dirección del documento debe coincidir con la de la cafetería. Un administrador revisará tu caso.',
                  style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        if (_error != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
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
}
