import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback? onReport;

  const ReviewCard({super.key, required this.review, this.onReport});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final createdDate = _formatDate(review.createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.brown100.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: review.userPhoto.isNotEmpty
                      ? CachedNetworkImageProvider(review.userPhoto)
                      : null,
                  backgroundColor: AppColors.brown50,
                  child: review.userPhoto.isEmpty
                      ? const Icon(Icons.person, color: AppColors.brown200)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName.isNotEmpty ? review.userName : 'Usuario',
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        createdDate,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: review.overallRating,
                      itemBuilder: (_, __) => const Icon(Icons.star, color: AppColors.gold),
                      itemCount: 5,
                      itemSize: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      review.overallRating.toStringAsFixed(1),
                      style: theme.textTheme.titleSmall,
                    ),
                    if (onReport != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.flag_outlined, size: 16, color: AppColors.gray600),
                        onPressed: onReport,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _miniRating('Calidad', review.qualityRating, theme),
                const SizedBox(width: 12),
                _miniRating('Sabrozura', review.flavorRating, theme),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _miniRating('Tostado', review.roastRating, theme),
                const SizedBox(width: 12),
                _miniRating('Servicio', review.serviceRating, theme),
              ],
            ),
            if (review.comment.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(review.comment, style: theme.textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }

  Widget _miniRating(String label, double rating, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelSmall),
        Row(
          children: [
            RatingBarIndicator(
              rating: rating,
              itemBuilder: (_, __) => const Icon(Icons.circle, color: AppColors.gold, size: 10),
              itemCount: 5,
              itemSize: 10,
            ),
            const SizedBox(width: 4),
            Text(
              rating.toStringAsFixed(1),
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Hoy';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';
    if (diff.inDays < 30) return 'Hace ${diff.inDays ~/ 7} semanas';
    return '${date.day}/${date.month}/${date.year}';
  }
}
