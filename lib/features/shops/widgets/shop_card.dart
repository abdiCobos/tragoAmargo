import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/coffee_shop.dart';

class ShopCard extends StatefulWidget {
  final CoffeeShop shop;
  final VoidCallback onTap;
  final int index;

  const ShopCard({super.key, required this.shop, required this.onTap, this.index = 0});

  @override
  State<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Duration(milliseconds: 400 + (widget.index * 80).clamp(0, 300)));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: () {
            _ctrl.reverse().then((_) => widget.onTap());
          },
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
                    width: 120, height: 140,
                    child: _shopImage(),
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
                            Text(widget.shop.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text(widget.shop.address,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.shop.averageRating,
                                  itemBuilder: (_, a) => const Icon(Icons.star, color: AppColors.star),
                                  itemCount: 5, itemSize: 16,
                                ),
                                const SizedBox(width: 4),
                                Text('(${widget.shop.totalReviews})',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                        Row(children: [
                          _tag(widget.shop.priceRange),
                          const SizedBox(width: 6),
                          if (widget.shop.hasWiFi) _tag('WiFi'),
                          if (widget.shop.seatingMode.isNotEmpty) ...[const SizedBox(width: 6), _tag(widget.shop.seatingMode)],
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _shopImage() {
    final photos = widget.shop.photos;
    if (photos.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: photos.first, fit: BoxFit.cover,
        placeholder: (_, a) => Container(color: AppColors.surface, child: const Icon(Icons.coffee, color: AppColors.tertiary, size: 40)),
        errorWidget: (_, a, b) => Container(color: AppColors.surface, child: const Icon(Icons.coffee, color: AppColors.tertiary, size: 40)),
      );
    }
    return Container(color: AppColors.surface, child: const Icon(Icons.coffee, color: AppColors.tertiary, size: 40));
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
    );
  }
}
