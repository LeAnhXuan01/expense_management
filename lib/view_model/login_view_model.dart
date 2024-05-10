import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String _username = '';
  String _password = '';
  bool _obscurePassword = true;

  String get username => _username;
  String get password => _password;
  bool get obscurePassword => _obscurePassword;

  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }
}
