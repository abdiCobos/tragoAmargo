import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/reviews_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/firestore_service.dart';
import '../../../models/notification.dart';

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
      userName: auth.user?.displayName ?? 'Usuario',
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
          id: '', userId: shop.verifiedOwnerUid!, title: 'Nueva reseña en ${shop.name}',
          body: '${auth.user?.displayName ?? 'Alguien'} calificó tu cafetería',
          type: 'new_review', shopId: widget.shopId, createdAt: DateTime.now(),
        ));
      }
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(reviews.isEditing ? '¡Reseña actualizada!' : '¡Reseña publicada!'),
          backgroundColor: AppColors.secondary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewsProvider>(
      builder: (context, reviews, _) {
        final isEdit = reviews.existingReview != null;

        return Scaffold(
          appBar: AppBar(title: Text(isEdit ? 'Editar Reseña' : 'Escribir Reseña')),
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
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.edit, color: AppColors.secondary),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text('Ya tienes una reseña. Puedes editarla.',
                              style: TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                _buildRatingSection(
                  'Calidad del grano',
                  'Evalúa la calidad y frescura del café',
                  _qualityRating,
                  (v) => setState(() => _qualityRating = v),
                ),
                const SizedBox(height: 20),
                _buildRatingSection(
                  'Sabrozura',
                  'Qué tan sabroso está el café',
                  _flavorRating,
                  (v) => setState(() => _flavorRating = v),
                ),
                const SizedBox(height: 20),
                _buildRatingSection(
                  'Manejo del tostado',
                  'Qué tan bien manejan los niveles de tostado',
                  _roastRating,
                  (v) => setState(() => _roastRating = v),
                ),
                const SizedBox(height: 20),
                _buildRatingSection(
                  'Servicio',
                  'Atención del personal y ambiente del lugar',
                  _serviceRating,
                  (v) => setState(() => _serviceRating = v),
                ),
                const SizedBox(height: 24),
                const Text('Comentario',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _commentController,
                  maxLines: 4,
                  decoration: const InputDecoration(hintText: 'Comparte tu experiencia...'),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: reviews.isLoading ? null : _submit,
                    child: reviews.isLoading
                        ? const SizedBox(
                            width: 24, height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(isEdit ? 'Actualizar Reseña' : 'Publicar Reseña'),
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

  Widget _buildRatingSection(
    String title, String subtitle, double currentRating, ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
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
                full: const Icon(Icons.star, color: AppColors.star),
                half: const Icon(Icons.star_half, color: AppColors.star),
                empty: const Icon(Icons.star_border, color: AppColors.star),
              ),
              onRatingUpdate: onChanged,
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentRating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
