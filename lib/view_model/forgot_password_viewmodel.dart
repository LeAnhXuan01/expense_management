import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  String _email = '';

  String get email => _email;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }
}
