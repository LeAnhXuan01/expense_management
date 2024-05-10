import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenViewModel {
  final SharedPreferences _prefs;

  SplashScreenViewModel(this._prefs);

  Future<String> decideNextScreen() async {
    bool isFirstTime = _prefs.getBool('isFirstTime') ?? true;
    await Future.delayed(const Duration(seconds: 3)); // Simulate loading
    return isFirstTime ? '/onboarding' : '/home';
  }
}
