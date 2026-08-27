import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashReporting {
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    _initialized = true;

    if (kIsWeb) return;

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  static Future<void> log(dynamic message) async {
    if (kIsWeb) {
      if (kDebugMode) debugPrint('[Crashlytics-WebLog] $message');
      return;
    }
    if (kDebugMode) {
      debugPrint('[Crashlytics] $message');
      return;
    }
    await FirebaseCrashlytics.instance.log(message.toString());
  }

  static Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    bool fatal = false,
    String? reason,
  }) async {
    if (kIsWeb) {
      if (kDebugMode) {
        debugPrint('[Crashlytics-WebERROR] ${reason ?? exception}');
        if (stack != null) debugPrint(stack.toString());
      }
      return;
    }
    if (kDebugMode) {
      debugPrint('[Crashlytics ERROR] ${reason ?? exception}');
      if (stack != null) debugPrint(stack.toString());
      return;
    }
    if (reason != null) {
      await FirebaseCrashlytics.instance.setCustomKey('reason', reason);
    }
    await FirebaseCrashlytics.instance.recordError(
      exception,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }

  static Future<void> recordFlutterError(FlutterErrorDetails details) async {
    if (kIsWeb || kDebugMode) return;
    await FirebaseCrashlytics.instance.recordFlutterError(details);
  }

  static Future<void> setUserIdentifier(String identifier) async {
    if (kIsWeb) return;
    await FirebaseCrashlytics.instance.setUserIdentifier(identifier);
  }

  static Future<void> setCustomKey(String key, dynamic value) async {
    if (kIsWeb) return;
    await FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
  }
}
