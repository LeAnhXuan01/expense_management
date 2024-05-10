import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view_model/splash_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashScreenViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _initViewModel();
  }

  Future<void> _initViewModel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _viewModel = SplashScreenViewModel(prefs);
    });
    _navigateNextScreen();
  }

  void _navigateNextScreen() async {
    final nextScreen = await _viewModel.decideNextScreen();
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 129, 71, 229),
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          height: 200,
          width: 200,
        ),
      ),
    );
  }
}
