import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/coffee_shop.dart';

class ShopCard extends StatelessWidget {
  final CoffeeShop shop;
  final VoidCallback onTap;

  const ShopCard({super.key, required this.shop, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth > 600 ? 140.0 : screenWidth * 0.32;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: SizedBox(
                width: imageWidth, height: 140,
                child: shop.photos.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: shop.photos.first, fit: BoxFit.cover,
                        placeholder: (_, a) => Container(color: AppColors.surface, child: const Icon(Icons.coffee, color: AppColors.tertiary, size: 40)),
                        errorWidget: (_, a, b) => Container(color: AppColors.surface, child: const Icon(Icons.coffee, color: AppColors.tertiary, size: 40)),
                      )
                    : Container(color: AppColors.surface, child: const Icon(Icons.coffee, color: AppColors.tertiary, size: 40)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(shop.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(shop.address,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Row(children: [
                          RatingBarIndicator(
                            rating: shop.averageRating,
                            itemBuilder: (_, a) => const Icon(Icons.star, color: AppColors.star),
                            itemCount: 5, itemSize: 16,
                          ),
                          const SizedBox(width: 4),
                          Text('(${shop.totalReviews})', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ]),
                      ],
                    ),
                    Row(children: [
                      _tag(shop.priceRange), const SizedBox(width: 6),
                      if (shop.hasWiFi) _tag('WiFi'),
                      if (shop.seatingMode.isNotEmpty) ...[const SizedBox(width: 6), _tag(shop.seatingMode)],
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
    );
  }
}
