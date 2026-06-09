import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/coffee_shops_provider.dart';
import '../../widgets/empty_state.dart';
import '../shops/shop_detail_screen.dart';
import '../shops/widgets/shop_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer2<AuthProvider, CoffeeShopsProvider>(
      builder: (context, auth, shopProvider, _) {
        if (!auth.isAuthenticated) {
          return EmptyState(
            icon: Icons.favorite_border,
            title: l10n.guestFavoritesMessage,
            subtitle: l10n.guestFavoritesSubtitle,
            buttonText: l10n.login,
            onButtonPressed: () => Navigator.pushNamed(context, '/login'),
          );
        }

        final favoriteIds = auth.appUser?.favoriteShops ?? [];
        final favoriteShops = shopProvider.shops
            .where((s) => favoriteIds.contains(s.id))
            .toList();

        if (favoriteShops.isEmpty) {
          return EmptyState(
            icon: Icons.favorite_border,
            title: l10n.noFavorites,
            subtitle: l10n.noFavoritesSubtitle,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            shopProvider.loadShops();
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 80),
            itemCount: favoriteShops.length,
            itemBuilder: (context, index) {
              final shop = favoriteShops[index];
              return ShopCard(
                shop: shop,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShopDetailScreen(shopId: shop.id),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
