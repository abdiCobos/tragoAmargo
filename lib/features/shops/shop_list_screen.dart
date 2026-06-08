import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/coffee_shops_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/empty_state.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/shop_card.dart';
import 'shop_detail_screen.dart';
import 'add_shop_screen.dart';

class ShopListScreen extends StatefulWidget {
  const ShopListScreen({super.key});

  @override
  State<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilters() {
    final provider = context.read<CoffeeShopsProvider>();
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.filters,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          provider.clearFilters();
                          Navigator.pop(ctx);
                        },
                        child: Text(l10n.clear),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.roastLevel,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      l10n.roastClaro,
                      l10n.roastMedio,
                      l10n.roastOscuro,
                      l10n.brewingEspresso
                    ].map((roast) {
                      final selected = provider.roastFilter == roast;
                      return ChoiceChip(
                        label: Text(roast),
                        selected: selected,
                        onSelected: (val) {
                          setModalState(() {});
                          provider.setRoastFilter(val ? roast : null);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.priceRange,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [r'$', r'$$', r'$$$'].map((price) {
                      final selected = provider.priceFilter == price;
                      return ChoiceChip(
                        label: Text(price),
                        selected: selected,
                        onSelected: (val) {
                          setModalState(() {});
                          provider.setPriceFilter(val ? price : null);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.wifi),
                    value: provider.wifiFilter ?? false,
                    activeTrackColor: AppColors.secondary,
                    onChanged: (val) {
                      setModalState(() {});
                      provider.setWifiFilter(val ? true : null);
                    },
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(l10n.proximity,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: l10n.proximityHint,
                      prefixIcon: const Icon(Icons.location_city),
                      isDense: true,
                      suffixIcon: provider.cityFilter != null
                          ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                              setModalState(() {});
                              provider.setCityFilter(null);
                            })
                          : null,
                    ),
                    onSubmitted: (v) {
                      setModalState(() {});
                      provider.setCityFilter(v.isEmpty ? null : v);
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: l10n.searchHint,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context
                                    .read<CoffeeShopsProvider>()
                                    .setSearchQuery(null);
                              },
                            )
                          : null,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onChanged: (value) {
                      setState(() {});
                      context
                          .read<CoffeeShopsProvider>()
                          .setSearchQuery(value.isEmpty ? null : value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Consumer<CoffeeShopsProvider>(
                  builder: (context, provider, _) {
                    return Badge(
                      isLabelVisible: provider.hasActiveFilters,
                      child: IconButton(
                        onPressed: _openFilters,
                        icon: const Icon(Icons.tune),
                        style: IconButton.styleFrom(
                          backgroundColor: provider.hasActiveFilters
                              ? AppColors.secondary.withValues(alpha: 0.2)
                              : Colors.grey.shade100,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<CoffeeShopsProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.shops.isEmpty) {
                  return LoadingIndicator(message: l10n.loading);
                }

                if (provider.shops.isEmpty) {
                  return EmptyState(
                    icon: Icons.coffee_outlined,
                    title: l10n.noShops,
                    subtitle: l10n.noShopsSubtitle,
                    buttonText: l10n.addShop,
                    onButtonPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddShopScreen()),
                      );
                    },
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    provider.loadShops();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 80),
                    itemCount: provider.shops.length,
                    itemBuilder: (context, index) {
                      final shop = provider.shops[index];
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
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final auth = context.read<AuthProvider>();
          if (!await auth.requireLogin(context)) return;
          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddShopScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
