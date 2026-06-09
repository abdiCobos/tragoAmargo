import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../models/notification.dart';
import '../../l10n/app_localizations.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        context.read<FirestoreService>().markAllRead(auth.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notifications)),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (!auth.isAuthenticated) {
            return Center(child: Text(l10n.notificationsLogin, style: const TextStyle(color: AppColors.textSecondary)));
          }

          return StreamBuilder<List<AppNotification>>(
            stream: context.read<FirestoreService>().getNotifications(auth.user!.uid),
            builder: (_, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }
              final notifs = snap.data ?? [];
              if (notifs.isEmpty) {
                return Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.notifications_none, size: 64, color: AppColors.tertiary),
                    const SizedBox(height: 12),
                    Text(l10n.noNotificationsYet, style: const TextStyle(color: AppColors.textSecondary)),
                  ]),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifs.length,
                itemBuilder: (_, i) {
                  final n = notifs[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: n.read ? AppColors.background : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: n.read ? null : Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                    child: Row(children: [
                      Icon(_iconFor(n.type), color: _colorFor(n.type), size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(n.title, style: TextStyle(fontWeight: n.read ? FontWeight.normal : FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(n.body, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text(_formatDate(n.createdAt, l10n), style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        ]),
                      ),
                    ]),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime d, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes.toString());
    if (diff.inHours < 24) return l10n.hoursAgo(diff.inHours.toString());
    return '${d.day}/${d.month}/${d.year}';
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'claim_approved': return Icons.verified;
      case 'review_reply': return Icons.reply;
      case 'new_review': return Icons.star;
      case 'welcome': return Icons.coffee;
      default: return Icons.notifications;
    }
  }

  Color _colorFor(String type) {
    switch (type) {
      case 'claim_approved': return AppColors.secondary;
      case 'review_reply': return AppColors.primary;
      case 'new_review': return AppColors.star;
      case 'welcome': return AppColors.tertiary;
      default: return AppColors.textSecondary;
    }
  }
}
