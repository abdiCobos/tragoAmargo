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
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 65, height: 65,
              child: item.photo.isNotEmpty
                  ? CachedNetworkImage(imageUrl: item.photo, fit: BoxFit.cover,
                      placeholder: (_, a) => Container(color: AppColors.surface),
                      errorWidget: (_, a, b) => Container(color: AppColors.surface,
                          child: const Icon(Icons.local_drink, color: AppColors.tertiary, size: 24)),
                    )
                  : Container(color: AppColors.surface,
                      child: const Icon(Icons.local_drink, color: AppColors.tertiary, size: 24)),
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
                      child: Text(item.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    ),
                    if (item.showPrice)
                      Text('\$${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(item.category, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (item.averageRating > 0) ...[
                      RatingBarIndicator(
                        rating: item.averageRating,
                        itemBuilder: (_, a) => const Icon(Icons.star, color: AppColors.star, size: 14),
                        itemCount: 5, itemSize: 14,
                      ),
                      const SizedBox(width: 4),
                      Text('(${item.totalRatings})',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                    if (item.isSignature) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.star.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Insignia',
                            style: TextStyle(fontSize: 10, color: AppColors.star, fontWeight: FontWeight.bold)),
                      ),
                    ],
                    const Spacer(),
                    if (onRate != null)
                      TextButton.icon(
                        onPressed: onRate,
                        icon: const Icon(Icons.star, size: 14, color: AppColors.star),
                        label: const Text('Calificar', style: TextStyle(fontSize: 11)),
                        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
                      ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.textSecondary),
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
    );
  }
}
