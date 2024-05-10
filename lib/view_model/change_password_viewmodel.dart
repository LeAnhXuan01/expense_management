import 'package:flutter/material.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  String _newPassword = '';
  String _confirmPassword = '';
  bool _obscurePassword = true;

  String get newPassword => _newPassword;
  String get confirmPassword => _confirmPassword;
  bool get obscurePassword => _obscurePassword;

  void setNewPassword(String value) {
    _newPassword = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }
}
