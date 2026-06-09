import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'core/utils/crash_reporting.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyD5ESjRa_f9d1vuEHWP9g7E8Dg5s6joYOs',
      authDomain: 'tragoamargo-ee5c5.firebaseapp.com',
      projectId: 'tragoamargo-ee5c5',
      storageBucket: 'tragoamargo-ee5c5.firebasestorage.app',
      messagingSenderId: '1041702706373',
      appId: '1:1041702706373:web:a62f0ae99245e5ae1624ac',
      measurementId: 'G-45WQ891VX4',
    ),
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (!kDebugMode) FirebaseCrashlytics.instance.recordFlutterError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (!kDebugMode) FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  CrashReporting.init();

  runApp(const TragoAmargoApp());
}
