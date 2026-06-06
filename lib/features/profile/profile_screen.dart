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

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  List<Review> _userReviews = [];
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadReviews());
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadReviews() async {
    final auth = context.read<AuthProvider>();
    if (!auth.isAuthenticated) return;
    final firestore = context.read<FirestoreService>();
    final reviews = await firestore.getReviewsByUser(auth.user!.uid);
    if (mounted) setState(() => _userReviews = reviews);
  }

  Future<void> _refresh() async {
    await _loadReviews();
    _animController.reset();
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.isAuthenticated) return _buildGuestView();
        final user = auth.user!;
        final appUser = auth.appUser;

        return RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
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
                            radius: 18, backgroundColor: AppColors.secondary,
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
                    _statRow(Icons.favorite, '${appUser?.favoriteShops.length ?? 0}', 'Favoritos'),
                    _statRow(Icons.rate_review, '${_userReviews.length}', 'Reseñas'),
                    _statRow(Icons.calendar_today, _fmt(appUser?.createdAt ?? DateTime.now()), 'Miembro desde'),
                    if (_userReviews.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity, height: 44,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => UserReviewsScreen(userId: user.uid, userName: user.displayName ?? 'Usuario'),
                            ));
                          },
                          icon: const Icon(Icons.list_alt, size: 18),
                          label: const Text('Ver todas mis reseñas'),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity, height: 52,
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
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGuestView() {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (_, val, child) => Transform.scale(scale: val, child: child),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: const Icon(Icons.coffee, size: 56, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Inicia sesión para comenzar a reseñar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text('Guarda tus cafeterías favoritas y comparte tu opinión',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  textAlign: TextAlign.center),
              const SizedBox(height: 28),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                builder: (_, val, child) => Opacity(opacity: val, child: child),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  icon: const Icon(Icons.person),
                  label: const Text('Iniciar Sesión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statRow(IconData icon, String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(icon, color: AppColors.secondary, size: 20),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ]),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto actualizada')),
      );
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
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final reviews = snapshot.data ?? [];
          if (reviews.isEmpty) {
            return const Center(child: Text('No ha escrito reseñas aún', style: TextStyle(color: AppColors.textSecondary)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (_, i) {
              final r = reviews[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: List.generate(5, (j) => Icon(
                          j < r.overallRating.round() ? Icons.star : Icons.star_border,
                          size: 16, color: AppColors.star)),
                      ),
                      if (r.comment.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(r.comment, style: const TextStyle(fontSize: 14)),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
