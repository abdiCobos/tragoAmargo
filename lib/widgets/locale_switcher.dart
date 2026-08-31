import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

class LocaleSwitcher extends StatelessWidget {
  const LocaleSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (_, localeProv, __) {
        final current = localeProv.locale.languageCode;
        final isEs = current == 'es';
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: ToggleButtons(
              isSelected: [isEs, !isEs],
              onPressed: (index) {
                localeProv.setLocale(Locale(index == 0 ? 'es' : 'en'));
              },
              borderRadius: BorderRadius.circular(8),
              constraints: const BoxConstraints(minHeight: 28, minWidth: 36),
              fillColor: theme.colorScheme.primaryContainer,
              selectedColor: theme.colorScheme.onPrimaryContainer,
              color: theme.colorScheme.onSurface,
              children: const [
                Text('ES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text('EN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }
}
