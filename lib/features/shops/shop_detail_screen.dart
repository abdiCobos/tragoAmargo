import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/coffee_shops_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/reviews_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../models/review.dart';
import '../../models/coffee_shop.dart';
import '../../models/menu_item.dart';
import '../../widgets/loading_indicator.dart';
import 'widgets/photo_gallery.dart';
import 'widgets/product_card.dart';
import 'widgets/opening_hours_widget.dart';
import '../reviews/review_form_screen.dart';
import 'claim_shop_screen.dart';
import 'add_product_screen.dart';
import 'rate_product_screen.dart';
import 'manage_menu_screen.dart';
import 'rate_menu_item_screen.dart';
import 'widgets/menu_item_card.dart';

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
      context.read<ReviewsProvider>().loadReviews(widget.shopId);
    });
  }

  Future<void> _addPhoto(CoffeeShop shop) async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (photo == null || !mounted) return;
    final bytes = await photo.readAsBytes();
    final storage = context.read<StorageService>();
    final fs = context.read<FirestoreService>();
    final url = await storage.uploadImageBytes(bytes, name: 'shop_${shop.id}');
    final updated = shop.copyWith(photos: [...shop.photos, url]);
    await fs.updateCoffeeShop(updated);
    if (!mounted) return;
    context.read<CoffeeShopsProvider>().selectShop(widget.shopId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Foto agregada'), backgroundColor: AppColors.secondary),
    );
  }

  Future<void> _deleteMenuItem(MenuItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar ítem'),
        content: Text('¿Eliminar "${item.name}" del menú?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar', style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (confirm == true && mounted) {
      final fs = context.read<FirestoreService>();
      await fs.deleteMenuItem(item.shopId, item.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ítem eliminado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<CoffeeShopsProvider, AuthProvider>(
        builder: (context, shopProv, auth, _) {
          if (shopProv.isLoading || shopProv.selectedShop == null) {
            return const LoadingIndicator(message: 'Cargando cafetería...');
          }

          final shop = shopProv.selectedShop!;
          final isFav = auth.isFavorite(shop.id);
          final isOwner = auth.isOwnerOfShop(shop.verifiedOwnerUid);
          final isPendingClaim = shop.verifiedOwnerUid == null;

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
                  if (isOwner)
                    IconButton(
                      icon: const Icon(Icons.add_a_photo, color: Colors.white),
                      tooltip: 'Agregar fotos',
                      onPressed: () => _addPhoto(shop),
                    ),
                  IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? AppColors.error : Colors.white),
                    onPressed: () => auth.toggleFavorite(shop.id),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(shop.name,
                                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                if (isOwner)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text('Dueño',
                                        style: TextStyle(fontSize: 11, color: AppColors.secondary, fontWeight: FontWeight.bold)),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (shop.averageRating > 0) ...[
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: shop.averageRating,
                              itemBuilder: (_, _a) => const Icon(Icons.star, color: AppColors.star),
                              itemCount: 5, itemSize: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(shop.averageRating.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(' (${shop.totalReviews} reseñas)',
                                style: const TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 18),
                          const SizedBox(width: 4),
                          Expanded(child: Text(shop.address,
                              style: const TextStyle(color: AppColors.textSecondary))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _chip(Icons.attach_money, shop.priceRange),
                          const SizedBox(width: 8),
                          if (shop.hasWiFi) _chip(Icons.wifi, 'WiFi'),
                          if (shop.seatingMode.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            _chip(Icons.chair, shop.seatingMode),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (isPendingClaim)
                        _actionButton(
                          icon: Icons.verified_outlined,
                          label: '¿Eres el dueño? Acredítate',
                          color: AppColors.star,
                          onPressed: () async {
                            if (!await auth.requireLogin(context)) return;
                            if (!context.mounted) return;
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => ClaimShopScreen(shop: shop)));
                          },
                        ),
                      if (isOwner) ...[
                        _actionButton(
                          icon: Icons.restaurant_menu,
                          label: 'Administrar Menú',
                          color: AppColors.secondary,
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => ManageMenuScreen(shopId: shop.id))),
                        ),
                        const SizedBox(height: 8),
                      ],
                      const SizedBox(height: 24),
                      const Divider(),
                      if (shop.originAndAltitude.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _section(Icons.landscape, 'Origen y Altura', shop.originAndAltitude),
                      ],
                      if (shop.roastLevels.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _section(Icons.local_fire_department, 'Niveles de Tostado', null,
                          Wrap(spacing: 8, children: shop.roastLevels.map((r) => Chip(label: Text(r))).toList())),
                      ],
                      if (shop.brewingMethods.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _section(Icons.science, 'Métodos de Preparación', null,
                          Wrap(spacing: 8, children: shop.brewingMethods.map((m) => Chip(label: Text(m))).toList())),
                      ],
                      if (shop.description.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _section(Icons.description, 'Descripción', shop.description),
                      ],
                      if (shop.openingHours.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        OpeningHoursWidget(openingHours: shop.openingHours),
                      ],
                      if (shop.phone.isNotEmpty || shop.instagram.isNotEmpty) ...[
                        const SizedBox(height: 16), const Divider(), const SizedBox(height: 16),
                        const Text('Contacto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        if (shop.phone.isNotEmpty)
                          Row(children: [
                            const Icon(Icons.phone, color: AppColors.secondary, size: 20),
                            const SizedBox(width: 8), Text(shop.phone),
                          ]),
                        if (shop.instagram.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(children: [
                            const Icon(Icons.camera_alt, color: AppColors.secondary, size: 20),
                            const SizedBox(width: 8), Text('@${shop.instagram}'),
                          ]),
                        ],
                      ],
                      if (shop.averageQuality > 0 || shop.averageFlavor > 0 || shop.averageRoast > 0 || shop.averageService > 0) ...[
                        const SizedBox(height: 24), const Divider(), const SizedBox(height: 16),
                        const Text('Calificaciones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        _ratingRow('Calidad del grano', shop.averageQuality),
                        _ratingRow('Sabrozura', shop.averageFlavor),
                        _ratingRow('Manejo del tostado', shop.averageRoast),
                        _ratingRow('Servicio', shop.averageService),
                      ],
                      if (shopProv.menuItems.isNotEmpty) ...[
                        const SizedBox(height: 24), const Divider(), const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text('Menú', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Text('${shopProv.menuItems.length} items',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...shopProv.menuItems.map((item) => MenuItemCard(
                              item: item,
                              onRate: isOwner ? null : () async {
                                if (!await auth.requireLogin(context)) return;
                                if (!context.mounted) return;
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => RateMenuItemScreen(item: item)));
                              },
                              onDelete: isOwner ? () => _deleteMenuItem(item) : null,
                            )),
                      ],
                      if (shopProv.currentProducts.isNotEmpty) ...[
                        const SizedBox(height: 24), const Divider(), const SizedBox(height: 16),
                        const Text('Bebidas insignia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 210,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: shopProv.currentProducts.length,
                            itemBuilder: (_, i) => ProductCard(
                              product: shopProv.currentProducts[i],
                              onRate: isOwner ? null : () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => RateProductScreen(product: shopProv.currentProducts[i]))),
                            ),
                          ),
                        ),
                      ],
                      if (!isOwner) ...[
                        const SizedBox(height: 24), const Divider(), const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  if (!await auth.requireLogin(context)) return;
                                  if (!context.mounted) return;
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) => ReviewFormScreen(shopId: shop.id)));
                                },
                                icon: const Icon(Icons.rate_review),
                                label: const Text('Reseña'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  if (!await auth.requireLogin(context)) return;
                                  auth.toggleFavorite(shop.id);
                                },
                                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                                    color: isFav ? AppColors.error : AppColors.primary),
                                label: Text(isFav ? 'Guardado' : 'Favorito'),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),
                      Consumer<ReviewsProvider>(
                        builder: (context, reviews, _) {
                          if (reviews.isLoading && reviews.reviews.isEmpty) {
                            return const LoadingIndicator(message: 'Cargando reseñas...');
                          }
                          if (reviews.reviews.isEmpty) return const SizedBox.shrink();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              const SizedBox(height: 16),
                              const Text('Reseñas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              ...reviews.reviews.map((r) => _reviewCard(r)),
                            ],
                          );
                        },
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

  Widget _actionButton({required IconData icon, required String label, required Color color, required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        label: Text(label, style: TextStyle(color: color)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withValues(alpha: 0.5)),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _section(IconData icon, String title, String? content, [Widget? child]) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, color: AppColors.secondary, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ]),
      const SizedBox(height: 8),
      if (content != null) Text(content, style: const TextStyle(fontSize: 15)),
      if (child != null) child,
    ]);
  }

  Widget _ratingRow(String label, double rating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        SizedBox(width: 150, child: Text(label, style: const TextStyle(fontSize: 14))),
        RatingBarIndicator(
          rating: rating,
          itemBuilder: (_, _a) => const Icon(Icons.star, color: AppColors.star),
          itemCount: 5, itemSize: 16,
        ),
        const SizedBox(width: 8),
        Text(rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ]),
    );
  }

  Widget _reviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _viewProfile(review),
            child: Row(
              children: [
                CircleAvatar(radius: 16, backgroundColor: AppColors.primary,
                  child: Text(review.userName.isNotEmpty ? review.userName[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
                const SizedBox(width: 8),
                Text(review.userName,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.textSecondary),
                const Spacer(),
                Row(children: List.generate(5, (i) => Icon(
                    i < review.overallRating.round() ? Icons.star : Icons.star_border,
                    size: 14, color: AppColors.star))),
              ],
            ),
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(review.comment, style: const TextStyle(fontSize: 13)),
          ],
        ],
      ),
    );
  }

  void _viewProfile(Review review) async {
    final fs = context.read<FirestoreService>();
    final userReviews = await fs.getReviewsByUser(review.userId);
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 24, backgroundColor: AppColors.primary,
                    child: Text(review.userName.isNotEmpty ? review.userName[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.userName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${userReviews.length} reseñas escritas',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16), const Divider(), const SizedBox(height: 8),
              const Text('Reseñas', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ...userReviews.take(5).map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Row(children: List.generate(5, (i) => Icon(
                            i < r.overallRating.round() ? Icons.star : Icons.star_border,
                            size: 14, color: AppColors.star))),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(r.comment.isNotEmpty ? r.comment : 'Sin comentario',
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
