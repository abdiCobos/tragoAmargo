import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/coffee_shops_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/loading_indicator.dart';
import 'widgets/photo_gallery.dart';
import 'widgets/product_card.dart';
import 'widgets/opening_hours_widget.dart';
import '../reviews/review_form_screen.dart';

class ShopDetailScreen extends StatefulWidget {
  final String shopId;

  const ShopDetailScreen({super.key, required this.shopId});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoffeeShopsProvider>().selectShop(widget.shopId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<CoffeeShopsProvider, AuthProvider>(
        builder: (context, shopProvider, authProvider, _) {
          if (shopProvider.isLoading || shopProvider.selectedShop == null) {
            return const LoadingIndicator(message: 'Cargando cafetería...');
          }

          final shop = shopProvider.selectedShop!;
          final isFav = authProvider.isFavorite(shop.id);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: AppColors.primary,
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  background: PhotoGallery(photos: shop.photos),
                ),
                actions: [
                  IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? AppColors.error : Colors.white),
                    onPressed: () => authProvider.toggleFavorite(shop.id),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (shop.averageRating > 0) ...[
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: shop.averageRating,
                              itemBuilder: (_, __) =>
                                  const Icon(Icons.star, color: AppColors.star),
                              itemCount: 5,
                              itemSize: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              shop.averageRating.toStringAsFixed(1),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' (${shop.totalReviews} reseñas)',
                              style: const TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              color: AppColors.textSecondary, size: 18),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(shop.address,
                                style: const TextStyle(color: AppColors.textSecondary)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildInfoChip(Icons.attach_money, shop.priceRange),
                          const SizedBox(width: 8),
                          if (shop.hasWiFi) _buildInfoChip(Icons.wifi, 'WiFi'),
                          if (shop.hasOutdoorSeating) ...[
                            const SizedBox(width: 8),
                            _buildInfoChip(Icons.wb_sunny_outlined, 'Terraza'),
                          ],
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      if (shop.originAndAltitude.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildSection(
                          icon: Icons.landscape,
                          title: 'Origen y Altura',
                          content: shop.originAndAltitude,
                        ),
                      ],
                      if (shop.roastLevels.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildSection(
                          icon: Icons.local_fire_department,
                          title: 'Niveles de Tostado',
                          child: Wrap(
                            spacing: 8,
                            children: shop.roastLevels.map((r) => Chip(label: Text(r))).toList(),
                          ),
                        ),
                      ],
                      if (shop.brewingMethods.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildSection(
                          icon: Icons.science,
                          title: 'Métodos de Preparación',
                          child: Wrap(
                            spacing: 8,
                            children: shop.brewingMethods
                                .map((m) => Chip(label: Text(m)))
                                .toList(),
                          ),
                        ),
                      ],
                      if (shop.description.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildSection(
                          icon: Icons.description,
                          title: 'Descripción',
                          content: shop.description,
                        ),
                      ],
                      if (shop.openingHours.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        OpeningHoursWidget(openingHours: shop.openingHours),
                      ],
                      if (shop.phone.isNotEmpty || shop.instagram.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        const Text('Contacto',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        if (shop.phone.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.phone, color: AppColors.secondary, size: 20),
                              const SizedBox(width: 8),
                              Text(shop.phone),
                            ],
                          ),
                        if (shop.instagram.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.camera_alt, color: AppColors.secondary, size: 20),
                              const SizedBox(width: 8),
                              Text('@${shop.instagram}'),
                            ],
                          ),
                        ],
                      ],
                      if (shop.averageQuality > 0 || shop.averageFlavor > 0 || shop.averageRoast > 0) ...[
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        const Text('Calificaciones',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        _buildRatingRow('Calidad del grano', shop.averageQuality),
                        _buildRatingRow('Sabrozura', shop.averageFlavor),
                        _buildRatingRow('Manejo del tostado', shop.averageRoast),
                      ],
                      if (shopProvider.currentProducts.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        const Text('Productos',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: shopProvider.currentProducts.length,
                            itemBuilder: (_, i) =>
                                ProductCard(product: shopProvider.currentProducts[i]),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReviewFormScreen(shopId: shop.id),
                            ),
                          );
                        },
                        icon: const Icon(Icons.rate_review),
                        label: const Text('Escribir Reseña'),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    String? content,
    Widget? child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.secondary, size: 20),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        if (content != null) Text(content, style: const TextStyle(fontSize: 15)),
        if (child != null) child,
      ],
    );
  }

  Widget _buildRatingRow(String label, double rating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          RatingBarIndicator(
            rating: rating,
            itemBuilder: (_, __) => const Icon(Icons.star, color: AppColors.star),
            itemCount: 5,
            itemSize: 16,
          ),
          const SizedBox(width: 8),
          Text(rating.toStringAsFixed(1),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
