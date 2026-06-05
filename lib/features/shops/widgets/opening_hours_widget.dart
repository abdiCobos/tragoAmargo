import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class OpeningHoursWidget extends StatelessWidget {
  final Map<String, String> openingHours;

  const OpeningHoursWidget({super.key, required this.openingHours});

  @override
  Widget build(BuildContext context) {
    if (openingHours.isEmpty) return const SizedBox.shrink();

    final orderedDays = [
      'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Horarios',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
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
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    openingHours[day]!,
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
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
