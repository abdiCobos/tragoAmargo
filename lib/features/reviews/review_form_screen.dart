import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/reviews_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/firestore_service.dart';
import '../../../models/notification.dart';
import '../../../l10n/app_localizations.dart';

class ReviewFormScreen extends StatefulWidget {
  final String shopId;

  const ReviewFormScreen({super.key, required this.shopId});

  @override
  State<ReviewFormScreen> createState() => _ReviewFormScreenState();
}

class _ReviewFormScreenState extends State<ReviewFormScreen> {
  final _commentController = TextEditingController();
  double _qualityRating = 3;
  double _flavorRating = 3;
  double _roastRating = 3;
  double _serviceRating = 3;

  AppLocalizations get l10n => AppLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final reviews = context.read<ReviewsProvider>();
      if (auth.user != null) {
        reviews.checkExistingReview(widget.shopId, auth.user!.uid).then((_) {
          if (mounted && reviews.existingReview != null) {
            setState(() {
              _qualityRating = reviews.existingReview!.qualityRating;
              _flavorRating = reviews.existingReview!.flavorRating;
              _roastRating = reviews.existingReview!.roastRating;
              _serviceRating = reviews.existingReview!.serviceRating;
              _commentController.text = reviews.existingReview!.comment;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    final reviews = context.read<ReviewsProvider>();

    if (auth.user == null) return;

    final success = await reviews.addReview(
      shopId: widget.shopId,
      userId: auth.user!.uid,
      userName: auth.user?.displayName ?? l10n.user,
      userPhoto: auth.user?.photoURL ?? '',
      qualityRating: _qualityRating,
      flavorRating: _flavorRating,
      roastRating: _roastRating,
      serviceRating: _serviceRating,
      comment: _commentController.text.trim(),
    );

    if (success && mounted) {
      final fs = context.read<FirestoreService>();
      final shop = await fs.getCoffeeShop(widget.shopId);
      if (shop != null && shop.verifiedOwnerUid != null && shop.verifiedOwnerUid != auth.user!.uid) {
        fs.sendNotification(AppNotification(
          id: '', userId: shop.verifiedOwnerUid!, title: '${l10n.newReviewTitle} ${shop.name}',
          body: '${auth.user?.displayName ?? l10n.someone} ${l10n.newReviewBody}',
          type: 'new_review', shopId: widget.shopId, createdAt: DateTime.now(),
        ));
      }
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(reviews.isEditing ? l10n.reviewUpdated : l10n.reviewPublished),
          backgroundColor: AppColors.brown800,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<ReviewsProvider>(
      builder: (context, reviews, _) {
        final isEdit = reviews.existingReview != null;

        return Scaffold(
          appBar: AppBar(title: Text(isEdit ? l10n.editReview : l10n.writeReview)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isEdit)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.brown50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(l10n.alreadyReviewed, style: theme.textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  ),
                _buildRatingSection(l10n.quality, l10n.qualityDesc, _qualityRating, (v) => setState(() => _qualityRating = v), theme),
                const SizedBox(height: 20),
                _buildRatingSection(l10n.flavor, l10n.flavorDesc, _flavorRating, (v) => setState(() => _flavorRating = v), theme),
                const SizedBox(height: 20),
                _buildRatingSection(l10n.roast, l10n.roastDesc, _roastRating, (v) => setState(() => _roastRating = v), theme),
                const SizedBox(height: 20),
                _buildRatingSection(l10n.service, l10n.serviceDesc, _serviceRating, (v) => setState(() => _serviceRating = v), theme),
                const SizedBox(height: 24),
                Text(l10n.comment, style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _commentController,
                  maxLines: 4,
                  decoration: InputDecoration(hintText: l10n.commentHint),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: reviews.isLoading ? null : _submit,
                    child: reviews.isLoading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(isEdit ? l10n.updateReview : l10n.publishReview),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingSection(String title, String subtitle, double currentRating, ValueChanged<double> onChanged, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleSmall),
        Text(subtitle, style: theme.textTheme.bodySmall),
        const SizedBox(height: 8),
        Row(
          children: [
            RatingBar(
              initialRating: currentRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 36,
              ratingWidget: RatingWidget(
                full: const Icon(Icons.star, color: AppColors.gold),
                half: const Icon(Icons.star_half, color: AppColors.gold),
                empty: const Icon(Icons.star_border, color: AppColors.gold),
              ),
              onRatingUpdate: onChanged,
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.brown50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(currentRating.toStringAsFixed(1), style: theme.textTheme.headlineSmall),
            ),
          ],
        ),
      ],
    );
  }
}
