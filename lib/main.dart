
import 'package:expense_management/routes.dart';
import 'package:expense_management/view/user/login_screen.dart';
import 'package:expense_management/view/user/profile_screen.dart';
import 'package:expense_management/widget/bottom_navigatorbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app_providers.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase connected successfully!');
  } on FirebaseException catch (e) {
    print('Firebase connection error: $e');
  }
  // await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      routes: routes,
      home: LoginScreen(),
    ));
  }
}
