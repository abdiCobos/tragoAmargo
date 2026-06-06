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
    final createdDate = _formatDate(review.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.3)),
      ),
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
                backgroundColor: AppColors.surface,
                child: review.userPhoto.isEmpty
                    ? const Icon(Icons.person, color: AppColors.tertiary)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName.isNotEmpty ? review.userName : 'Usuario',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(createdDate,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Row(
                children: [
                  RatingBarIndicator(
                    rating: review.overallRating,
                    itemBuilder: (_, __) => const Icon(Icons.star, color: AppColors.star),
                    itemCount: 5,
                    itemSize: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(review.overallRating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (onReport != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.flag_outlined, size: 16, color: AppColors.textSecondary),
                      onPressed: onReport, padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _miniRating('Calidad', review.qualityRating),
              const SizedBox(width: 12),
              _miniRating('Sabrozura', review.flavorRating),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _miniRating('Tostado', review.roastRating),
              const SizedBox(width: 12),
              _miniRating('Servicio', review.serviceRating),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(review.comment, style: const TextStyle(fontSize: 14)),
          ],
        ],
      ),
    );
  }

  Widget _miniRating(String label, double rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        Row(
          children: [
            RatingBarIndicator(
              rating: rating,
              itemBuilder: (_, __) => const Icon(Icons.circle, color: AppColors.star, size: 10),
              itemCount: 5,
              itemSize: 10,
            ),
            const SizedBox(width: 4),
            Text(rating.toStringAsFixed(1),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
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
