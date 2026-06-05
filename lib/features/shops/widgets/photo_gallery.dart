import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';

class PhotoGallery extends StatelessWidget {
  final List<String> photos;

  const PhotoGallery({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return Container(
        height: 220,
        color: AppColors.surface,
        child: const Center(
          child: Icon(Icons.coffee, size: 64, color: AppColors.tertiary),
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: PageView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl: photos[index],
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (_, __) => Container(color: AppColors.surface),
            errorWidget: (_, __, ___) => Container(
              color: AppColors.surface,
              child: const Icon(Icons.broken_image, color: AppColors.tertiary),
            ),
          );
        },
      ),
    );
  }
}
