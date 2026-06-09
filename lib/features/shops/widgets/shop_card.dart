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
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth > 600 ? 140.0 : screenWidth * 0.32;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.brown100),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            SizedBox(
              width: imageWidth,
              height: 140,
              child: shop.photos.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: shop.photos.first,
                      fit: BoxFit.cover,
                      placeholder: (_, a) => Container(
                        color: AppColors.brown50,
                        child: const Icon(Icons.coffee, color: AppColors.brown200, size: 40),
                      ),
                      errorWidget: (_, a, b) => Container(
                        color: AppColors.brown50,
                        child: const Icon(Icons.coffee, color: AppColors.brown200, size: 40),
                      ),
                    )
                  : Container(
                      color: AppColors.brown50,
                      child: const Icon(Icons.coffee, color: AppColors.brown200, size: 40),
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
                        Text(
                          shop.name,
                          style: theme.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          shop.address,
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: shop.averageRating,
                              itemBuilder: (_, a) => const Icon(Icons.star, color: AppColors.gold),
                              itemCount: 5,
                              itemSize: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${shop.totalReviews})',
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _tag(shop.priceRange, theme),
                        const SizedBox(width: 6),
                        if (shop.hasWiFi) _tag('WiFi', theme),
                        if (shop.seatingMode.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          _tag(shop.seatingMode, theme),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.brown50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColors.brown700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
