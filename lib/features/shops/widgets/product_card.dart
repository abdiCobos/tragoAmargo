import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onRate;

  const ProductCard({super.key, required this.product, this.onRate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              height: 100,
              width: 160,
              child: product.photo.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: product.photo, fit: BoxFit.cover,
                      placeholder: (_, _a) => Container(color: AppColors.surface),
                      errorWidget: (_, _a, _b) => Container(
                        color: AppColors.surface,
                        child: const Icon(Icons.coffee, color: AppColors.tertiary),
                      ),
                    )
                  : Container(
                      color: AppColors.surface,
                      child: const Icon(Icons.coffee, color: AppColors.tertiary),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text('\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.secondary)),
                const SizedBox(height: 4),
                if (product.averageRating > 0)
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: product.averageRating,
                        itemBuilder: (_, _a) => const Icon(Icons.star, color: AppColors.star, size: 14),
                        itemCount: 5, itemSize: 14,
                      ),
                      const SizedBox(width: 4),
                      Text('(${product.totalRatings})',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                if (onRate != null) ...[
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: OutlinedButton(
                      onPressed: onRate,
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        side: const BorderSide(color: AppColors.star),
                      ),
                      child: const Text('Calificar', style: TextStyle(fontSize: 11)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
