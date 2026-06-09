import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/storage_service.dart';
import 'services/geocoding_service.dart';
import 'providers/auth_provider.dart';
import 'providers/coffee_shops_provider.dart';
import 'providers/reviews_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/locale_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/home/home_screen.dart';
import 'l10n/app_localizations.dart';

class AuthGate extends StatefulWidget {
  static const String homeRoute = '/home';
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) Navigator.pushReplacementNamed(context, AuthGate.homeRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.coffee, size: 80, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(l10n.appTitle,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 8),
            Text(l10n.appTagline,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
            const SizedBox(height: 32),
            const CircularProgressIndicator(color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class TragoAmargoApp extends StatelessWidget {
  const TragoAmargoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => FirestoreService()),
        Provider(create: (_) => StorageService()),
        Provider(create: (_) => GeocodingService()),
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(
            ctx.read<AuthService>(),
            ctx.read<FirestoreService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CoffeeShopsProvider(
            ctx.read<FirestoreService>(),
            ctx.read<GeocodingService>(),
            ctx.read<StorageService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ReviewsProvider(ctx.read<FirestoreService>()),
        ),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()..load()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) => MaterialApp(
          title: 'Trago Amargo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: localeProvider.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          initialRoute: '/',
          routes: {
            '/': (context) => const AuthGate(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
          },
        ),
      ),
    );
  }
}
