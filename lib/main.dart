import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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

  runApp(const TragoAmargoApp());
}
