import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  String emailError = '';

  ForgotPasswordViewModel(){
    emailController.addListener(() {
      if (validateEmail(emailController.text)) {
        emailError = '';
        notifyListeners();
      }
    });
  }

  bool validateEmail(String email) {
    if (email.isEmpty) {
      emailError = 'Vui lòng nhập email.';
      return false;
    }
    if (email.contains('@gmail.com')) {
      emailError = 'Không cần nhập đuôi @gmail.com.';
      return false;
    }
    if (email.contains(RegExp(r'[!#$%^&*(),?":{}|<>]'))) {
      emailError = 'Email không được chứa ký tự đặc biệt.';
      return false;
    }
    emailError = '';
    return true;
  }

  bool next() {
    final email = emailController.text;
    emailError = '';
    if (!validateEmail(email)) {
      notifyListeners();
      return false;
    }
    return true;
  }
}
