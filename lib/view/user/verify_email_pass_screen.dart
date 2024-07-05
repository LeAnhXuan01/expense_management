import 'dart:async';
import 'package:expense_management/widget/custom_snackbar_1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../view_model/user/forgot_password_viewmodel.dart';
import '../../widget/custom_ElevatedButton_1.dart';
import '../../widget/custom_header_2.dart';
import '../../widget/custom_snackbar_2.dart';

class VerifyEmailPassScreen extends StatefulWidget {
  @override
  State<VerifyEmailPassScreen> createState() => _VerifyEmailPassScreenState();
}

class _VerifyEmailPassScreenState extends State<VerifyEmailPassScreen> {
  bool _isSendingVerification = false;
  bool _hasRecentlySentVerification = false;
  int _countdown = 60;
  Timer? _timer;

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _hasRecentlySentVerification = false;
          _timer?.cancel();
        }
      });
    });
  }

  void _sendPasswordResetEmail(ForgotPasswordViewModel viewModel) async {
    if (_hasRecentlySentVerification) {
      CustomSnackBar_2.show(context, 'Vui lòng thử lại sau ít phút.');
      return;
    }

    setState(() {
      _isSendingVerification = true;
    });

    try {
      final AuthService _authService = AuthService();
      await _authService.sendPasswordResetEmail(viewModel.emailController.text.trim() + '@gmail.com');
      setState(() {
        _hasRecentlySentVerification = true;
        _countdown = 60;
      });

      CustomSnackBar_2.show(context, 'Email đặt lại mật khẩu đã được gửi lại');
      _startCountdown();
    } catch (e) {
      print('Error sending password reset email: $e');
      if (e is FirebaseAuthException && e.code == 'too-many-requests') {
        CustomSnackBar_1.show(context, 'Quá nhiều yêu cầu gửi email đặt lại mật khẩu. Vui lòng thử lại sau ít phút.');
        setState(() {
          _hasRecentlySentVerification = true;
          _countdown = 60;
        });
        _startCountdown();
      } else {
        CustomSnackBar_1.show(context, 'Có lỗi xảy ra khi gửi email đặt lại mật khẩu. Vui lòng thử lại.');
      }
    }

    setState(() {
      _isSendingVerification = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<ForgotPasswordViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            CustomHeader_2(title: 'Xác thực Email'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Vui lòng kiểm tra email ',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${viewModel.emailController.text}@gmail.com',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            ),
                            TextSpan(
                              text:
                                  ' để được hướng dẫn đặt lại mật khẩu của bạn.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      CustomElavatedButton_1(
                        onPressed: (_isSendingVerification || _hasRecentlySentVerification)
                            ? null
                            : () => _sendPasswordResetEmail(viewModel),
                        text: 'Gửi lại email',
                      ),
                      if (_hasRecentlySentVerification)
                        Text(
                          'Vui lòng chờ $_countdown giây trước khi gửi lại email.',
                          style: TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                    text: 'Đã đổi mật khẩu thành công? ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    )),
                                TextSpan(
                                  text: 'Đăng nhập',
                                  style: const TextStyle(
                                      color: Colors.green,
                                      decoration: TextDecoration.underline,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacementNamed(
                                          context, '/login');
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ));
  }
}
