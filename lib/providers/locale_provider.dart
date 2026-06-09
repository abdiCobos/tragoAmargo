import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const _key = 'app_locale';
  Locale? _locale;

  Locale get locale => _locale ?? _systemLocale;

  Locale get _systemLocale {
    final system = WidgetsBinding.instance.platformDispatcher.locale;
    final supported = const ['en', 'es'];
    if (supported.contains(system.languageCode)) {
      return Locale(system.languageCode);
    }
    return const Locale('es');
  }

  bool get hasUserPreference => _locale != null;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null && ['en', 'es'].contains(code)) {
      _locale = Locale(code);
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }
}
