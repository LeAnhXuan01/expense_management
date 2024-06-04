import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_management/UI/login_screen.dart';
import 'package:expense_management/UI/splash_screen.dart';
import 'package:expense_management/routes.dart';
import 'package:expense_management/widget/bottom_navigatorbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'UI/wallet/wallet_screen.dart';
import 'api/firebase_api.dart';
import 'app_providers.dart';
// Import the firebase_app_check plugin
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo Firebase
  // try {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   print('Firebase connected successfully!');
  // } on FirebaseException catch (e) {
  //   print('Firebase connection error: $e');
  // }
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    // webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.playIntegrity,
  );
  await FirebaseApi().initNotificantions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
        child: MaterialApp(
      title: 'Expense Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: routes,
      home: LoginScreen(),
    ));
  }
}
