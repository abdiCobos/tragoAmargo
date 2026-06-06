import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/storage_service.dart';
import '../../services/firestore_service.dart';
import '../../models/review.dart';
import '../../models/app_user.dart';
import '../../models/coffee_shop.dart';
import '../shops/shop_detail_screen.dart';
import '../shops/widgets/shop_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Review> _userReviews = [];
  List<CoffeeShop> _favoriteShops = [];
  List<CoffeeShop> _ownedShops = [];
  bool _loadingOwned = false;
  bool _loadingReviews = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final auth = context.read<AuthProvider>();
    if (!auth.isAuthenticated) return;

    final fs = context.read<FirestoreService>();
    final reviews = await fs.getReviewsByUser(auth.user!.uid);
    final favIds = auth.appUser?.favoriteShops ?? [];
    final ownedIds = auth.appUser?.ownedShops ?? [];

    final favShops = <CoffeeShop>[];
    for (final id in favIds) {
      final shop = await fs.getCoffeeShop(id);
      if (shop != null) favShops.add(shop);
    }

    if (mounted) {
      setState(() {
        _userReviews = reviews;
        _favoriteShops = favShops;
        _loadingOwned = true;
        _loadingReviews = false;
      });
    }

    final ownedShops = <CoffeeShop>[];
    for (final id in ownedIds) {
      final shop = await fs.getCoffeeShop(id);
      if (shop != null) ownedShops.add(shop);
    }

    if (mounted) setState(() { _ownedShops = ownedShops; _loadingOwned = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.isAuthenticated) return _guestView();
        final user = auth.user!;
        final appUser = auth.appUser;

        return RefreshIndicator(
          onRefresh: () async { await _loadData(); },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50, backgroundColor: AppColors.surface,
                      backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                      child: user.photoURL == null ? const Icon(Icons.person, size: 50, color: AppColors.tertiary) : null,
                    ),
                    Positioned(bottom: 0, right: 0, child: CircleAvatar(
                      radius: 18, backgroundColor: AppColors.secondary,
                      child: IconButton(icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white), onPressed: () => _changePhoto(context)),
                    )),
                  ],
                ),
                const SizedBox(height: 16),
                Text(user.displayName ?? 'Usuario', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(user.email ?? '', style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                _stat(Icons.favorite, '${appUser?.favoriteShops.length ?? 0}', 'Favoritos'),
                _stat(Icons.rate_review, _loadingReviews ? '...' : '${_userReviews.length}', 'Reseñas', onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(
                    builder: (_) => UserReviewsScreen(userId: user.uid, userName: user.displayName ?? 'Usuario')));
                  _loadData();
                }),
                _stat(Icons.store, '${appUser?.ownedShops.length ?? 0}', 'Cafeterías', onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(
                    builder: (_) => UserShopsScreen(userId: user.uid, userName: user.displayName ?? 'Usuario')));
                  _loadData();
                }),
                _stat(Icons.calendar_today, _fmt(appUser?.createdAt ?? DateTime.now()), 'Miembro desde'),

                if (_ownedShops.isNotEmpty) ...[
                  const SizedBox(height: 24), const Divider(),
                  const SizedBox(height: 12),
                  const Text('Mis Cafeterías', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._ownedShops.map((s) => _ownerCard(s)),
                ],

                if (_favoriteShops.isNotEmpty) ...[
                  const SizedBox(height: 24), const Divider(),
                  const SizedBox(height: 12),
                  const Text('Mis Favoritos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._favoriteShops.map((s) => ShopCard(shop: s, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ShopDetailScreen(shopId: s.id))))),
                ],

                const SizedBox(height: 32),
                SizedBox(width: double.infinity, height: 52, child: OutlinedButton.icon(
                  onPressed: () async {
                    await auth.signOut();
                    if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
                  },
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: const Text('Cerrar Sesión', style: TextStyle(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error)),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _ownerCard(CoffeeShop shop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.verified, size: 16, color: AppColors.secondary),
            const SizedBox(width: 6),
            Expanded(child: Text(shop.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15), overflow: TextOverflow.ellipsis)),
          ]),
          const SizedBox(height: 4),
          Text(shop.address, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Row(children: [
            _tag('${shop.totalReviews} reseñas'),
            const SizedBox(width: 8),
            _tag(shop.averageRating > 0 ? shop.averageRating.toStringAsFixed(1) : 'Sin calif'),
          ]),
        ])),
        IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ShopDetailScreen(shopId: shop.id))),
            icon: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary)),
      ]),
    );
  }

  Widget _tag(String text) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.secondary, fontWeight: FontWeight.w600)));
  }

  Widget _guestView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0), duration: const Duration(milliseconds: 800), curve: Curves.elasticOut,
            builder: (_, val, child) => Transform.scale(scale: val, child: child),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface, shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: const Icon(Icons.coffee, size: 56, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Inicia sesión para comenzar a reseñar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const Text('Guarda tus cafeterías favoritas y comparte tu opinión',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: 28),
          ElevatedButton.icon(onPressed: () => Navigator.pushNamed(context, '/login'),
            icon: const Icon(Icons.person), label: const Text('Iniciar Sesión')),
        ],
      ),
    );
  }

  Widget _stat(IconData icon, String value, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
        Icon(icon, color: AppColors.secondary, size: 20), const SizedBox(width: 12),
        Text(label, style: TextStyle(color: onTap != null ? AppColors.primary : AppColors.textSecondary)),
        const Spacer(), Row(children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
          ],
        ]),
      ])),
    );
  }

  String _fmt(DateTime date) => '${date.day}/${date.month}/${date.year}';

  Future<void> _changePhoto(BuildContext context) async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (photo != null && context.mounted) {
      final storage = context.read<StorageService>();
      final auth = context.read<AuthProvider>();
      final user = auth.user;
      if (user == null) return;
      final bytes = await photo.readAsBytes();
      final url = await storage.uploadUserPhoto(user.uid, bytes);
      await user.updatePhotoURL(url);
      if (!context.mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Foto actualizada')));
    }
  }
}

class UserReviewsScreen extends StatelessWidget {
  final String userId;
  final String userName;
  const UserReviewsScreen({super.key, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reseñas de $userName')),
      body: FutureBuilder<List<Review>>(
        future: context.read<FirestoreService>().getReviewsByUser(userId),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final reviews = snap.data ?? [];
          if (reviews.isEmpty) return const Center(child: Text('No ha escrito reseñas', style: TextStyle(color: AppColors.textSecondary)));
          return ListView.builder(padding: const EdgeInsets.all(16), itemCount: reviews.length, itemBuilder: (_, i) {
            final r = reviews[i];
            return _ReviewCardWithShop(review: r);
          });
        },
      ),
    );
  }
}

class _ReviewCardWithShop extends StatelessWidget {
  final Review review;
  const _ReviewCardWithShop({required this.review});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CoffeeShop?>(
      future: context.read<FirestoreService>().getCoffeeShop(review.shopId),
      builder: (_, shopSnap) {
        final shop = shopSnap.data;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => ShopDetailScreen(shopId: review.shopId))),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (shop != null) ...[
                  Row(children: [
                    const Icon(Icons.store, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(child: Text(shop.name,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        overflow: TextOverflow.ellipsis)),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                  ]),
                  Text(shop.address,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                ],
                Row(children: List.generate(5, (j) =>
                    Icon(j < review.overallRating.round() ? Icons.star : Icons.star_border,
                        size: 16, color: AppColors.star))),
                if (review.comment.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(review.comment, style: const TextStyle(fontSize: 14)),
                ],
              ]),
            ),
          ),
        );
      },
    );
  }
}

class UserShopsScreen extends StatelessWidget {
  final String userId;
  final String userName;
  const UserShopsScreen({super.key, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cafeterías de $userName')),
      body: FutureBuilder<AppUser?>(
        future: context.read<FirestoreService>().getUser(userId),
        builder: (_, userSnap) {
          if (userSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final appUser = userSnap.data;
          final ownedIds = appUser?.ownedShops ?? [];
          if (ownedIds.isEmpty) {
            return const Center(child: Text('No ha publicado cafeterías', style: TextStyle(color: AppColors.textSecondary)));
          }
          return FutureBuilder<List<CoffeeShop>>(
            future: _loadShops(context, ownedIds),
            builder: (_, shopsSnap) {
              if (shopsSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }
              final shops = shopsSnap.data ?? [];
              if (shops.isEmpty) {
                return const Center(child: Text('No ha publicado cafeterías', style: TextStyle(color: AppColors.textSecondary)));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: shops.length,
                itemBuilder: (_, i) {
                  final shop = shops[i];
                  return ShopCard(
                    shop: shop,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ShopDetailScreen(shopId: shop.id))),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  static Future<List<CoffeeShop>> _loadShops(BuildContext context, List<String> ids) async {
    final fs = context.read<FirestoreService>();
    final shops = <CoffeeShop>[];
    for (final id in ids) {
      final shop = await fs.getCoffeeShop(id);
      if (shop != null) shops.add(shop);
    }
    return shops;
  }
}
