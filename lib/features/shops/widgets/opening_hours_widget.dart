import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class OpeningHoursWidget extends StatelessWidget {
  final Map<String, String> openingHours;

  const OpeningHoursWidget({super.key, required this.openingHours});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (openingHours.isEmpty) return const SizedBox.shrink();

    final orderedDays = [
      'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Horarios', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        ...orderedDays.where((d) => openingHours.containsKey(d)).map((day) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    day[0].toUpperCase() + day.substring(1),
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.brown50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    openingHours[day]!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
