import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class RegisterViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool hasEmailError = false;
  bool hasPasswordError = false;
  bool hasConfirmPasswordError = false;
  bool isFormValid = false;


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
    isFormValid = emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        !hasEmailError &&
        !hasPasswordError &&
        !hasConfirmPasswordError;
    notifyListeners();
  }

  Future<bool> register() async {
    final email = emailController.text;
    final newPassword = passwordController.text;

    final isEmailValid = !hasEmailError; // Kiểm tra xem không có lỗi về email
    final isPasswordValid = !hasPasswordError; // Kiểm tra xem không có lỗi về mật khẩu
    final isConfimPasswordValid = !hasConfirmPasswordError;
    if (!isEmailValid || !isPasswordValid || !isConfimPasswordValid) {
      notifyListeners();
      return false;
    }

    try {
      // Tạo tài khoản mới với Firebase Authentication
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email + '@gmail.com',
        password: newPassword,
      );

      // Gửi email xác thực
      await userCredential.user!.sendEmailVerification();

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emailError = 'Email này đã được sử dụng.';
      } else if (e.code == 'invalid-email') {
        emailError = 'Email không hợp lệ.';
      }
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> monitorEmailVerification(User user, String password) async {
    await user.reload();
    if (user.emailVerified) {
      // Lấy user ID từ Firebase Authentication
      String userId = user.uid;
      // Lưu thông tin người dùng vào Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'userId': userId,
        'email': user.email,
        'password': password,
      });

      return true;
    } else {
      return false;
    }
  }
}
