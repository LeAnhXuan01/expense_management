import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../services/auth_service.dart';
import '../../widget/custom_snackbar_1.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool hasEmailError = false;
  bool hasPasswordError = false;
  bool hasConfirmPasswordError = false;
  bool enableButton = false;

  String emailError = '';
  String passwordError = '';
  String confirmPasswordError = '';

  RegisterViewModel() {
    emailController.addListener(() {
      validateEmail(emailController.text);
    });

    passwordController.addListener(() {
      validatePassword(passwordController.text);
    });

    confirmPasswordController.addListener(() {
      validateConfirmPassword(confirmPasswordController.text, passwordController.text);
    });
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
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

  void validatePassword(String password) {
    if (password.length < 6 && passwordController.text.isNotEmpty) {
      passwordError = 'Mật khẩu phải dài ít nhất 6 ký tự.';
      hasPasswordError = true;
    } else if (password.length > 30 && passwordController.text.isNotEmpty) {
      passwordError = 'Mật khẩu dài không quá 30 ký tự.';
      hasPasswordError = true;
    } else {
      passwordError = '';
      hasPasswordError = false;
    }
    validateForm();
  }

  void validateConfirmPassword(String confirmPassword, String password) {
    if (confirmPassword != password) {
      confirmPasswordError = 'Mật khẩu và xác nhận mật khẩu không khớp.';
      hasConfirmPasswordError = true;
    } else {
      confirmPasswordError = '';
      hasConfirmPasswordError = false;
    }
    validateForm();
  }

  void validateForm() {
    enableButton = emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        !hasEmailError &&
        !hasPasswordError &&
        !hasConfirmPasswordError;
    notifyListeners();
  }

  // void resetFields() {
  //   emailController.clear();
  //   passwordController.clear();
  //   confirmPasswordController.clear();
  //   isPasswordVisible = false;
  //   isConfirmPasswordVisible = false;
  //   enableButton = false;
  //   notifyListeners();
  // }

  Future<bool> register(BuildContext context) async {
    final email = emailController.text.trim() + '@gmail.com';
    final newPassword = passwordController.text.trim();

    final isEmailValid = !hasEmailError; // Kiểm tra xem không có lỗi về email
    final isPasswordValid = !hasPasswordError; // Kiểm tra xem không có lỗi về mật khẩu
    final isConfirmPasswordValid = !hasConfirmPasswordError;
    if (!isEmailValid || !isPasswordValid || !isConfirmPasswordValid) {
      notifyListeners();
      return false;
    }

    try {
      // Tạo tài khoản mới với Firebase Authentication
      User? user = await _authService.createUserWithEmailAndPassword(email, newPassword);
      if (user != null) {
        // Gửi email xác thực
        await user.sendEmailVerification();
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emailError = 'Email này đã được sử dụng.';
      } else if (e.code == 'invalid-email') {
        emailError = 'Email không hợp lệ.';
      }
      // _showErrorSnackBar(context, emailError);
      notifyListeners();
      return false;
    } catch (e) {
      _showErrorSnackBar(context, 'Đã xảy ra lỗi. Vui lòng thử lại.');
      notifyListeners();
      return false;
    }
  }

  Future<void> saveUserToFirestore(String userId, String email, String password) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'userId': userId,
      'email': email,
      'password': password,
    });
  }

  Future<bool> monitorEmailVerification(User user, String password) async {
    await user.reload();
    if (user.emailVerified) {
      // Lấy user ID từ Firebase Authentication
      String userId = user.uid;
      // Lưu thông tin người dùng vào Firestore
      await saveUserToFirestore(userId, user.email!, password);
      return true;
    } else {
      return false;
    }
  }

  void _showErrorSnackBar(BuildContext context, String error) {
    CustomSnackBar_1.show(context, error);
  }
}
