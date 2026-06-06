import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/firestore_service.dart';
import '../../../models/coffee_shop.dart';

class ClaimShopScreen extends StatefulWidget {
  final CoffeeShop shop;
  const ClaimShopScreen({super.key, required this.shop});

  @override
  State<ClaimShopScreen> createState() => _ClaimShopScreenState();
}

class _ClaimShopScreenState extends State<ClaimShopScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _claimWithGps() async {
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
      setState(() { _error = 'Ve a ajustes y activa los permisos de ubicación.'; _loading = false; });
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

      final auth = context.read<AuthProvider>();
      final fs = context.read<FirestoreService>();

      await fs.updateCoffeeShop(
        widget.shop.copyWith(verifiedOwnerUid: auth.user!.uid),
      );

      await auth.addOwnedShop(widget.shop.id);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Te has acreditado como dueño'),
            backgroundColor: AppColors.secondary,
          ),
        );
      }
    } catch (e) {
      setState(() { _error = 'Error al obtener ubicación. Intenta de nuevo.'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acreditar como Dueño')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Verificación por GPS',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Debes estar físicamente en el local (máximo 20 metros de distancia) para acreditarte como dueño.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.store, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(widget.shop.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.location_on, color: AppColors.secondary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(widget.shop.address)),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.star.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.star, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Como dueño no podrás dejar reseñas en tu propia cafetería.',
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
                onPressed: _loading ? null : _claimWithGps,
                icon: _loading
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.gps_fixed),
                label: const Text('Verificar y reclamar'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
