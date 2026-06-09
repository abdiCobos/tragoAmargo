import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/crash_reporting.dart';
import '../../providers/coffee_shops_provider.dart';
import '../../models/coffee_shop.dart';
import '../shops/shop_detail_screen.dart';
import '../../l10n/app_localizations.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _userLocation;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    setState(() => _locating = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      if (mounted) {
        setState(() => _userLocation = LatLng(position.latitude, position.longitude));
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  double _distanceKm(LatLng a, LatLng b) {
    const r = 6371;
    final dLat = _degToRad(b.latitude - a.latitude);
    final dLon = _degToRad(b.longitude - a.longitude);
    final sinDLat = sin(dLat / 2);
    final sinDLon = sin(dLon / 2);
    final aVal = sinDLat * sinDLat + cos(_degToRad(a.latitude)) * cos(_degToRad(b.latitude)) * sinDLon * sinDLon;
    return 2 * r * atan2(sqrt(aVal), sqrt(1 - aVal));
  }

  double _degToRad(double deg) => deg * (pi / 180.0);

  int _estimatedMinutes(double km) => (km / 0.08).round().clamp(1, 999);

  String _formatDistance(double km) {
    if (km < 1) return '${(km * 1000).round()} m';
    return '${km.toStringAsFixed(1)} km';
  }

  void _showPreviewSheet(BuildContext context, CoffeeShop shop) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final userLoc = _userLocation;
    final double? distKm = userLoc != null
        ? _distanceKm(userLoc, LatLng(shop.location.latitude, shop.location.longitude))
        : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.gray400, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              Text(shop.name, style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
              const SizedBox(height: 4),
              if (shop.averageRating > 0)
                RatingBarIndicator(
                  rating: shop.averageRating,
                  itemBuilder: (context, index) => const Icon(Icons.star, color: AppColors.gold),
                  itemCount: 5, itemSize: 20,
                )
              else
                Text(l10n.noRating, style: theme.textTheme.bodySmall),
              if (shop.address.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(shop.address, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.gray600), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
              if (shop.priceRange.isNotEmpty || shop.hasWiFi) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.brown50, borderRadius: BorderRadius.circular(20)),
                      child: Text(shop.priceRange, style: theme.textTheme.labelMedium?.copyWith(color: AppColors.brown700)),
                    ),
                    if (shop.hasWiFi) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.brown50, borderRadius: BorderRadius.circular(20)),
                        child: Text('WiFi', style: theme.textTheme.labelMedium?.copyWith(color: AppColors.success)),
                      ),
                    ],
                  ],
                ),
              ],
              if (distKm != null) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.near_me, size: 16, color: AppColors.brown600),
                    const SizedBox(width: 4),
                    Text(
                      '${_formatDistance(distKm)}  ·  ${l10n.approxTime(_estimatedMinutes(distKm))}',
                      style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.brown600, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _openDirections(context, shop, l10n);
                      },
                      icon: const Icon(Icons.directions, size: 18),
                      label: Text(l10n.howToGetThere),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => ShopDetailScreen(shopId: shop.id),
                        ));
                      },
                      icon: const Icon(Icons.info_outline, size: 18),
                      label: Text(l10n.viewDetails),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(sheetContext).viewInsets.bottom),
            ],
          ),
        );
      },
    );
  }

  void _openDirections(BuildContext context, CoffeeShop shop, AppLocalizations l10n) {
    final dest = LatLng(shop.location.latitude, shop.location.longitude);
    final origin = _userLocation;
    final originParam = origin != null
        ? '${origin.latitude},${origin.longitude}'
        : '';

    final gmUrl = origin != null
        ? 'https://www.google.com/maps/dir/?api=1&origin=$originParam&destination=${dest.latitude},${dest.longitude}&travelmode=walking'
        : 'https://www.google.com/maps/search/?api=1&query=${dest.latitude},${dest.longitude}';

    final osmUrl = origin != null
        ? 'https://www.openstreetmap.org/directions?from=$originParam&to=${dest.latitude},${dest.longitude}#map=16/${dest.latitude}/${dest.longitude}'
        : 'https://www.openstreetmap.org/?mlat=${dest.latitude}&mlon=${dest.longitude}#map=16/${dest.latitude}/${dest.longitude}';

    // Launch URL directly — must happen inside the user gesture without async gap
    void launchAndClose(BuildContext ctx, String url) {
      debugPrint('[MapScreen] Opening: $url');
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      Navigator.of(ctx).pop();
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.chooseMapApp),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.map),
              title: Text(l10n.googleMaps),
              onTap: () => launchAndClose(ctx, gmUrl),
            ),
            ListTile(
              leading: const Icon(Icons.travel_explore),
              title: Text(l10n.openStreetMap),
              onTap: () => launchAndClose(ctx, osmUrl),
            ),
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: Text(l10n.openInBrowser),
              onTap: () => launchAndClose(ctx, gmUrl),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Consumer<CoffeeShopsProvider>(
      builder: (context, provider, _) {
        final shops = provider.shops
            .where((s) => s.location.latitude != 0 || s.location.longitude != 0)
            .toList();

        final center = shops.isNotEmpty
            ? LatLng(shops.first.location.latitude, shops.first.location.longitude)
            : const LatLng(20.6597, -103.3496);

        return Stack(
          children: [
            FlutterMap(
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
                    TextSourceAttribution('OpenStreetMap contributors', onTap: () {}),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    if (_userLocation != null)
                      Marker(
                        point: _userLocation!,
                        width: 28,
                        height: 28,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.gold, width: 2),
                          ),
                          child: const Center(
                            child: Icon(Icons.my_location, size: 14, color: AppColors.brown800),
                          ),
                        ),
                      ),
                    ...shops.map((shop) {
                      return Marker(
                        point: LatLng(shop.location.latitude, shop.location.longitude),
                        width: 200,
                        height: 80,
                        child: GestureDetector(
                          onTap: () => _showPreviewSheet(context, shop),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.2), blurRadius: 8)],
                                ),
                                child: Text(shop.name, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary)),
                              ),
                              const SizedBox(height: 2),
                              Icon(Icons.location_on, color: theme.colorScheme.primary, size: 32),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
            if (_locating)
              const Positioned(top: 16, left: 16, child: Card(
                child: Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
              )),
            Positioned(
              bottom: 16, left: 16, right: 16,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.1), blurRadius: 8)],
                  ),
                  child: Text(l10n.tapForPreview, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.gray600)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
