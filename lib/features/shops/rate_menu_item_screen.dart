import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/firestore_service.dart';
import '../../../models/menu_item.dart';

class RateMenuItemScreen extends StatefulWidget {
  final MenuItem item;
  const RateMenuItemScreen({super.key, required this.item});

  @override
  State<RateMenuItemScreen> createState() => _RateMenuItemScreenState();
}

class _RateMenuItemScreenState extends State<RateMenuItemScreen> {
  double _rating = 4;
  bool _saving = false;

  Future<void> _submit() async {
    setState(() => _saving = true);
    final fs = context.read<FirestoreService>();
    final item = widget.item;
    final newTotal = item.totalRatings + 1;
    final newAvg = ((item.averageRating * item.totalRatings) + _rating) / newTotal;

    await fs.rateMenuItem(
      shopId: item.shopId, itemId: item.id,
      averageRating: newAvg, totalRatings: newTotal,
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calificación guardada'), backgroundColor: AppColors.brown800),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.name)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_drink, size: 48, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(widget.item.name, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 4),
              if (widget.item.showPrice)
                Text('\$${widget.item.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(color: AppColors.gold)),
              const SizedBox(height: 32),
              Text('¿Qué tal esta bebida?', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              RatingBar(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 48,
                ratingWidget: RatingWidget(
                  full: const Icon(Icons.star, color: AppColors.gold),
                  half: const Icon(Icons.star_half, color: AppColors.gold),
                  empty: const Icon(Icons.star_border, color: AppColors.gold),
                ),
                onRatingUpdate: (v) => setState(() => _rating = v),
              ),
              const SizedBox(height: 8),
              Text(_rating.toStringAsFixed(1), style: theme.textTheme.headlineLarge),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: _saving ? null : _submit,
                  child: _saving
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Calificar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
