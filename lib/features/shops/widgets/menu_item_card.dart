import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/menu_item.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback? onRate;
  final VoidCallback? onDelete;

  const MenuItemCard({super.key, required this.item, this.onRate, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.brown100.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 65,
                height: 65,
                child: item.photo.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: item.photo,
                        fit: BoxFit.cover,
                        placeholder: (_, a) => Container(color: AppColors.brown50),
                        errorWidget: (_, a, b) => Container(
                          color: AppColors.brown50,
                          child: const Icon(Icons.local_drink, color: AppColors.brown200, size: 24),
                        ),
                      )
                    : Container(
                        color: AppColors.brown50,
                        child: const Icon(Icons.local_drink, color: AppColors.brown200, size: 24),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(item.name, style: theme.textTheme.titleSmall),
                      ),
                      if (item.showPrice)
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(item.category, style: theme.textTheme.labelSmall),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (item.averageRating > 0) ...[
                        RatingBarIndicator(
                          rating: item.averageRating,
                          itemBuilder: (_, a) => const Icon(Icons.star, color: AppColors.gold, size: 14),
                          itemCount: 5,
                          itemSize: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${item.totalRatings})',
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                      if (item.isSignature) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Insignia',
                            style: TextStyle(fontSize: 10, color: AppColors.gold, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (onRate != null)
                        TextButton.icon(
                          onPressed: onRate,
                          icon: const Icon(Icons.star, size: 14, color: AppColors.gold),
                          label: Text('Calificar', style: theme.textTheme.labelSmall),
                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.gray600),
                          onPressed: onDelete,
                          tooltip: 'Eliminar',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
