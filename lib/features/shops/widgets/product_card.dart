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
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(right: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.brown100.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              width: 160,
              child: product.photo.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: product.photo,
                      fit: BoxFit.cover,
                      placeholder: (_, _a) => Container(color: AppColors.brown50),
                      errorWidget: (_, _a, _b) => Container(
                        color: AppColors.brown50,
                        child: const Icon(Icons.coffee, color: AppColors.brown200),
                      ),
                    )
                  : Container(
                      color: AppColors.brown50,
                      child: const Icon(Icons.coffee, color: AppColors.brown200),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: theme.textTheme.titleSmall?.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (product.averageRating > 0)
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: product.averageRating,
                          itemBuilder: (_, _a) => const Icon(Icons.star, color: AppColors.gold, size: 14),
                          itemCount: 5,
                          itemSize: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.totalRatings})',
                          style: theme.textTheme.labelSmall,
                        ),
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
                          side: const BorderSide(color: AppColors.gold),
                        ),
                        child: Text('Calificar', style: theme.textTheme.labelSmall),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
