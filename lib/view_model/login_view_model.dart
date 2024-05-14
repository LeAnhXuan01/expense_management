import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String _name = '';
  String _password = '';
  bool _obscurePassword = true;

  String get name => _name;
  String get password => _password;
  bool get obscurePassword => _obscurePassword;


  void setName(String value) {
    _name = value;
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
