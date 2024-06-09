import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  bool isFormValid = false;
  bool hasEmailError = false;

  String emailError = '';

  ForgotPasswordViewModel() {
    emailController.addListener(() {
      validateEmail(emailController.text);
    });
  }

  void validateForm() {
    isFormValid = emailController.text.isNotEmpty && !hasEmailError;
    notifyListeners();
  }

  void validateEmail(String email) {
    if (email.contains('@gmail.com')) {
      emailError = 'Email không hợp lệ';
      hasEmailError = true;
    }else {
      emailError = '';
      hasEmailError = false;
    }
    validateForm();
  }

  Future<bool> next(BuildContext context) async {
    final isEmailValid = !hasEmailError;

    if (!isEmailValid) {
      notifyListeners();
      return false;
    }

    final email = emailController.text.trim() + '@gmail.com';

    try {
      // Kiểm tra xem email đã tồn tại trong Firestore chưa
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      // Nếu tồn tại ít nhất một tài khoản có cùng email trong Firestore
      if (querySnapshot.docs.isNotEmpty) {
        await sendVerificationEmail(email);
        return true;
      } else {
        emailError = 'Email này chưa được đăng ký.';
        notifyListeners();
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      emailError = 'Đã xảy ra lỗi. Vui lòng thử lại.';
      notifyListeners();
      return false;
    } catch (e) {
      // In ra lỗi khác (nếu có)
      print('Exception: $e');
      emailError = 'Đã xảy ra lỗi. Vui lòng thử lại.';
      notifyListeners();
      return false;
    }
  }

  Future<void> sendVerificationEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}


