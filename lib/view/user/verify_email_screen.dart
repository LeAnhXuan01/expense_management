import 'dart:async';

import 'package:expense_management/widget/custom_header_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/user/register_view_model.dart';
import '../../widget/custom_ElevatedButton_1.dart';
import '../../widget/custom_snackbar_1.dart';
import '../../widget/custom_snackbar_2.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
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

  void _sendEmailVerification(RegisterViewModel viewModel) async {
    if (_hasRecentlySentVerification) {
      CustomSnackBar_2.show(context, 'Vui lòng thử lại sau ít phút');
      return;
    }

    setState(() {
      _isSendingVerification = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        setState(() {
          _hasRecentlySentVerification = true;
          _countdown = 60;
        });

        CustomSnackBar_2.show(context, 'Email xác thực đã được gửi lại');
        _startCountdown();
      }
    } catch (e) {
      print('Error sending email verification: $e');
      if (e is FirebaseAuthException && e.code == 'too-many-requests') {
        CustomSnackBar_1.show(context, 'Quá nhiều yêu cầu gửi email xác thực. Vui lòng thử lại sau ít phút.');
        setState(() {
          _hasRecentlySentVerification = true;
          _countdown = 60;
        });
        _startCountdown();
      } else {
        CustomSnackBar_1.show(context, 'Có lỗi xảy ra khi gửi email xác thực. Vui lòng thử lại.');
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
    return Scaffold(
      body: Consumer<RegisterViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              CustomHeader_2(title: 'Xác thực Email'),
              SizedBox(height: 150),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Vui lòng kiểm tra email ',
                              style: TextStyle(fontSize: 16),
                            ),
                            TextSpan(
                              text: '${viewModel.emailController.text}@gmail.com',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            TextSpan(
                              text: ' và nhấp vào liên kết xác thực để hoàn tất quá trình đăng ký.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      CustomElavatedButton_1(
                        onPressed: () async {
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            await user.reload();
                            if (user.emailVerified) {
                              await viewModel.monitorEmailVerification(
                                  user, viewModel.passwordController.text);
                              await CustomSnackBar_2.show(context, 'Đăng ký thành công');
                              Navigator.pushReplacementNamed(context, '/login');
                            } else {
                              CustomSnackBar_1.show(context, 'Email chưa được xác thực. Vui lòng kiểm tra lại.');
                            }
                          }
                        },
                        text: 'Tôi đã xác thực',
                      ),
                      SizedBox(height: 20),
                      CustomElavatedButton_1(
                        onPressed: (_isSendingVerification || _hasRecentlySentVerification)
                            ? null
                            : () => _sendEmailVerification(viewModel),
                        text: 'Gửi lại email xác thực',
                      ),
                      if (_hasRecentlySentVerification)
                        Text(
                          'Vui lòng chờ $_countdown giây trước khi gửi lại email.',
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
