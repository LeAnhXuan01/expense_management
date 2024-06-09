import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widget/custom_snackbar_1.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isFormValid = false;
  bool isPasswordVisible = false;

  String loginError = '';

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  LoginViewModel() {
    emailController.addListener(validateForm);
    passwordController.addListener(validateForm);
  }


  void validateForm() {
    isFormValid = emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    notifyListeners();
  }

  Future<void> updatePasswordInFirestore(String userId, String newPassword) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'password': newPassword,
      });
    } catch (e) {
      print('Error updating password in Firestore: $e');
    }
  }

  Future<bool> login(BuildContext context) async {
    final email = emailController.text.trim() + '@gmail.com';
    final password = passwordController.text.trim();


    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.reload(); // Reload user để cập nhật trạng thái email đã xác thực hay chưa
        if (user.emailVerified) {
          // Email đã được xác thực, cho phép đăng nhập
          // Email đã được xác thực, cập nhật mật khẩu mới vào Firestore
          await updatePasswordInFirestore(user.uid, password);

          // Xóa mật khẩu cũ từ Firestore (nếu cần)
          // await deleteOldPasswordFromFirestore(user.uid);

          return true;
        } else {
          // Email chưa được xác thực, hiển thị thông báo lỗi
          loginError = 'Tài khoản này Email chưa được xác thực';
          _showErrorSnackBar(context, loginError);
          notifyListeners();
          return false;
        }
      }
      return false;
    } on FirebaseAuthException catch (e) {
      print('Error code: ${e.code}'); // In ra mã lỗi
      switch (e.code) {
        // case 'user-not-found':
        //   loginError = 'Không tìm thấy tài khoản này.';
        //   break;
        // case 'wrong-password':
        //   loginError = 'Mật khẩu không đúng.';
        //   break;
        case 'invalid-email':
          loginError = 'Email không hợp lệ.';
          break;
        case 'invalid-credential':
          loginError = 'Email hoặc mật khẩu không đúng.';
          break;
        case 'network-request-failed':
          loginError = 'Mạng không ổn định. Vui lòng kiểm tra lại mạng.';
          break;
        default:
          loginError = 'Đăng nhập thất bại. Vui lòng thử lại.';
          break;
      }
      _showErrorSnackBar(context, loginError);
      notifyListeners();
      return false;
    } catch (e) {
      loginError = 'Đã xảy ra lỗi. Vui lòng thử lại.';
      _showErrorSnackBar(context, loginError);
      notifyListeners();
      return false;
    }
  }


  void _showErrorSnackBar(BuildContext context, String error) {
    CustomSnackBar_1.show(context, error);
  }

}
