import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/coffee_shops_provider.dart';
import '../shops/shop_detail_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeShopsProvider>(
      builder: (context, provider, _) {
        final shops = provider.shops
            .where((s) => s.location.latitude != 0 || s.location.longitude != 0)
            .toList();

        final center = shops.isNotEmpty
            ? LatLng(shops.first.location.latitude, shops.first.location.longitude)
            : const LatLng(20.6597, -103.3496);

        return FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: 13.0,
            maxZoom: 18.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'trago.amargo',
            ),
            RichAttributionWidget(
              popupInitialDisplayDuration: const Duration(seconds: 3),
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () {},
                ),
              ],
            ),
            MarkerLayer(
              markers: shops.map((shop) {
                return Marker(
                  point: LatLng(shop.location.latitude, shop.location.longitude),
                  width: 200,
                  height: 80,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShopDetailScreen(shopId: shop.id),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Text(
                            shop.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Icon(Icons.location_on, color: AppColors.primary, size: 32),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
