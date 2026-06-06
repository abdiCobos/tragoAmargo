import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/storage_service.dart';
import '../../services/firestore_service.dart';
import '../../models/review.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Review> _userReviews = [];

  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadReviews());
  }

  Future<void> _loadReviews() async {
    final auth = context.read<AuthProvider>();
    if (!auth.isAuthenticated) return;

    setState(() { });
    final firestore = context.read<FirestoreService>();
    final reviews = await firestore.getReviewsByUser(auth.user!.uid);
    if (mounted) setState(() { _userReviews = reviews; });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.isAuthenticated) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_outline, size: 80, color: AppColors.tertiary),
                const SizedBox(height: 16),
                const Text('Inicia sesión para ver tu perfil',
                    style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text('Iniciar Sesión'),
                ),
              ],
            ),
          );
        }

        final user = auth.user!;
        final appUser = auth.appUser;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.surface,
                    backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                    child: user.photoURL == null
                        ? const Icon(Icons.person, size: 50, color: AppColors.tertiary)
                        : null,
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.secondary,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                        onPressed: () => _changePhoto(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(user.displayName ?? 'Usuario',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(user.email ?? '', style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              _buildStatRow(Icons.favorite, '${appUser?.favoriteShops.length ?? 0}', 'Favoritos'),
              _buildStatRow(Icons.rate_review, '${_userReviews.length}', 'Reseñas'),
              _buildStatRow(Icons.calendar_today, _formatDate(appUser?.createdAt ?? DateTime.now()), 'Miembro desde'),
              if (_userReviews.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                const Text('Mis Reseñas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ..._userReviews.map((r) => _buildReviewItem(r)),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await auth.signOut();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
                    }
                  },
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: const Text('Cerrar Sesión', style: TextStyle(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatRow(IconData icon, String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Row(
            children: List.generate(5, (i) => Icon(
              i < review.overallRating.round() ? Icons.star : Icons.star_border,
              size: 16, color: AppColors.star,
            )),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              review.comment.isNotEmpty ? review.comment : 'Sin comentario',
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto actualizada')),
      );
    }
  }
}
