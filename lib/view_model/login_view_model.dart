import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  String loginError = '';

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<bool> login(BuildContext context) async {
    final email = emailController.text + '@gmail.com';
    final password = passwordController.text;

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
          return true;
        } else {
          // Email chưa được xác thực, hiển thị thông báo lỗi
          loginError = 'Thông tin xác thực không hợp lệ.';
          _showErrorDialog(context, loginError);
          notifyListeners();
          return false;
        }
      }
      return false;
    } on FirebaseAuthException catch (e) {
      print('Error code: ${e.code}'); // In ra mã lỗi
      switch (e.code) {
        case 'user-not-found':
          loginError = 'Không tìm thấy tài khoản này.';
          break;
        case 'wrong-password':
          loginError = 'Mật khẩu không đúng.';
          break;
        case 'invalid-email':
          loginError = 'Email không hợp lệ.';
          break;
        case 'invalid-credential':
          loginError = 'Thông tin xác thực không hợp lệ.';
          break;
        default:
          loginError = 'Đăng nhập thất bại. Vui lòng thử lại.';
          break;
      }
      _showErrorDialog(context, loginError);
      notifyListeners();
      return false;
    } catch (e) {
      loginError = 'Đã xảy ra lỗi. Vui lòng thử lại.';
      _showErrorDialog(context, loginError);
      notifyListeners();
      return false;
    }
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lỗi đăng nhập'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
