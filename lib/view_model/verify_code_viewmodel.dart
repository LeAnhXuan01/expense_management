import 'package:flutter/material.dart';

class VerifyCodeViewModel extends ChangeNotifier {
  String _verificationCode = '';
  int _remainingTime = 60;

  String get verificationCode => _verificationCode;
  int get remainingTime => _remainingTime;

  void setVerificationCode(String value) {
    _verificationCode = value;
    notifyListeners();
  }

  void decrementRemainingTime() {
    if (_remainingTime > 0) {
      _remainingTime--;
      notifyListeners();
    }
  }

  void resetRemainingTime() {
    _remainingTime = 60;
    notifyListeners();
  }
}
