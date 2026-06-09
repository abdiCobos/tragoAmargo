import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../services/storage_service.dart';
import '../../services/firestore_service.dart';
import '../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.isAuthenticated) return _guestView(context, l10n, theme);
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
                      radius: 50, backgroundColor: AppColors.brown50,
                      backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                      child: user.photoURL == null ? const Icon(Icons.person, size: 50, color: AppColors.brown200) : null,
                    ),
                    Positioned(bottom: 0, right: 0, child: CircleAvatar(
                      radius: 18, backgroundColor: AppColors.brown800,
                      child: IconButton(icon: const Icon(Icons.camera_alt, size: 18, color: AppColors.white), onPressed: () => _changePhoto(context)),
                    )),
                  ],
                ),
                const SizedBox(height: 16),
                Text(user.displayName ?? l10n.user, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(user.email ?? '', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 24),
                _stat(Icons.favorite, '${appUser?.favoriteShops.length ?? 0}', l10n.favorites, theme),
                _stat(Icons.rate_review, _loadingReviews ? '...' : '${_userReviews.length}', l10n.reviews, theme, onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(
                    builder: (_) => UserReviewsScreen(userId: user.uid, userName: user.displayName ?? l10n.user)));
                  _loadData();
                }),
                _stat(Icons.store, '${appUser?.ownedShops.length ?? 0}', l10n.myCafesStat, theme, onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(
                    builder: (_) => UserShopsScreen(userId: user.uid, userName: user.displayName ?? l10n.user)));
                  _loadData();
                }),
                _stat(Icons.calendar_today, _fmt(appUser?.createdAt ?? DateTime.now()), l10n.memberSince, theme),

                if (_ownedShops.isNotEmpty) ...[
                  const SizedBox(height: 24), const Divider(),
                  const SizedBox(height: 12),
                  Text(l10n.myCafes, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  ..._ownedShops.map((s) => _ownerCard(s, l10n, theme)),
                ],

                if (_favoriteShops.isNotEmpty) ...[
                  const SizedBox(height: 24), const Divider(),
                  const SizedBox(height: 12),
                  Text(l10n.myFavorites, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  ..._favoriteShops.map((s) => ShopCard(shop: s, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ShopDetailScreen(shopId: s.id))))),
                ],

                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.language, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 12),
                    Text(l10n.language, style: theme.textTheme.bodyMedium),
                    const Spacer(),
                    Consumer<LocaleProvider>(
                      builder: (_, localeProv, __) {
                        final current = localeProv.locale.languageCode;
                        return SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'es', label: Text('ES')),
                            ButtonSegment(value: 'en', label: Text('EN')),
                          ],
                          selected: {current},
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            textStyle: WidgetStateProperty.all(
                              theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            minimumSize: WidgetStateProperty.all(const Size(44, 34)),
                          ),
                          onSelectionChanged: (val) {
                            localeProv.setLocale(Locale(val.first));
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(width: double.infinity, height: 52, child: OutlinedButton.icon(
                  onPressed: () async {
                    await auth.signOut();
                    if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
                  },
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: Text(l10n.logout, style: const TextStyle(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error)),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _ownerCard(CoffeeShop shop, AppLocalizations l10n, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.brown50, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.verified, size: 16, color: AppColors.brown800),
            const SizedBox(width: 6),
            Expanded(child: Text(shop.name, style: theme.textTheme.titleSmall, overflow: TextOverflow.ellipsis)),
          ]),
          const SizedBox(height: 4),
          Text(shop.address, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Row(children: [
            _tag('${shop.totalReviews} ${l10n.reviews}'),
            const SizedBox(width: 8),
            _tag(shop.averageRating > 0 ? shop.averageRating.toStringAsFixed(1) : l10n.noRating),
          ]),
        ])),
        IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ShopDetailScreen(shopId: shop.id))),
            icon: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.gray600)),
      ]),
    );
  }

  Widget _tag(String text) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.brown700, fontWeight: FontWeight.w600)));
  }

  Widget _guestView(BuildContext ctx, AppLocalizations l10n, ThemeData theme) {
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
                color: AppColors.brown50, shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.brown800.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: const Icon(Icons.coffee, size: 56, color: AppColors.brown800),
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.guestMessage,
              style: theme.textTheme.titleLarge?.copyWith(color: AppColors.textPrimary), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(l10n.guestSubtitle,
              style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
          const SizedBox(height: 28),
          ElevatedButton.icon(onPressed: () => Navigator.pushNamed(ctx, '/login'),
            icon: const Icon(Icons.person), label: Text(l10n.login)),
        ],
      ),
    );
  }

  Widget _stat(IconData icon, String value, String label, ThemeData theme, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20), const SizedBox(width: 12),
        Text(label, style: TextStyle(color: onTap != null ? theme.colorScheme.primary : AppColors.gray600)),
        const Spacer(), Row(children: [
          Text(value, style: theme.textTheme.titleMedium),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.gray600),
          ],
        ]),
      ])),
    );
  }

  String _fmt(DateTime date) => '${date.day}/${date.month}/${date.year}';

  Future<void> _changePhoto(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.photoUpdated)));
    }
  }
}

class UserReviewsScreen extends StatelessWidget {
  final String userId;
  final String userName;
  const UserReviewsScreen({super.key, required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reviewsOfUser(userName))),
      body: FutureBuilder<List<Review>>(
        future: context.read<FirestoreService>().getReviewsByUser(userId),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
          }
          final reviews = snap.data ?? [];
          if (reviews.isEmpty) return Center(child: Text(l10n.noUserReviews, style: theme.textTheme.bodyMedium));
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
    final theme = Theme.of(context);
    return FutureBuilder<CoffeeShop?>(
      future: context.read<FirestoreService>().getCoffeeShop(review.shopId),
      builder: (_, shopSnap) {
        final shop = shopSnap.data;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => ShopDetailScreen(shopId: review.shopId))),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (shop != null) ...[
                  Row(children: [
                    Icon(Icons.store, size: 16, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Expanded(child: Text(shop.name,
                        style: theme.textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis)),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.gray600),
                  ]),
                  Text(shop.address,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                ],
                Row(children: List.generate(5, (j) =>
                    Icon(j < review.overallRating.round() ? Icons.star : Icons.star_border,
                        size: 16, color: AppColors.gold))),
                if (review.comment.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(review.comment, style: theme.textTheme.bodyMedium),
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
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.shopsOfUser(userName))),
      body: FutureBuilder<AppUser?>(
        future: context.read<FirestoreService>().getUser(userId),
        builder: (_, userSnap) {
          if (userSnap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
          }
          final appUser = userSnap.data;
          final ownedIds = appUser?.ownedShops ?? [];
          if (ownedIds.isEmpty) {
            return Center(child: Text(l10n.noPublishedShops, style: theme.textTheme.bodyMedium));
          }
          return FutureBuilder<List<CoffeeShop>>(
            future: _loadShops(context, ownedIds),
            builder: (_, shopsSnap) {
              if (shopsSnap.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
              }
              final shops = shopsSnap.data ?? [];
              if (shops.isEmpty) {
                return Center(child: Text(l10n.noPublishedShops, style: theme.textTheme.bodyMedium));
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
