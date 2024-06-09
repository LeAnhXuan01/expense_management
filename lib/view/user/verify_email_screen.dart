  import 'package:expense_management/widget/custom_header_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
  import '../../view_model/user/register_view_model.dart';
  import '../../widget/custom_ElevatedButton_1.dart';
import '../../widget/custom_snackbar_1.dart';
import '../../widget/custom_snackbar_2.dart';

  class VerifyEmailScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      RegisterViewModel viewModel = Provider.of<RegisterViewModel>(context);

      return Scaffold(
        body: Column(
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
                              fontWeight: FontWeight.bold, // Đặt định dạng cho phần email
                              color: Colors.blue, // Màu sắc cho phần email
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
                            await viewModel.monitorEmailVerification(user, viewModel.passwordController.text);
                            CustomSnackBar_2.show(context, 'Đăng ký thành công.');
                            Navigator.of(context).pushNamed('/login');
                          } else {
                            CustomSnackBar_1.show(context, 'Email chưa được xác thực. Vui lòng kiểm tra lại.');
                          }
                        }
                      },
                      text: 'Tôi đã xác thực',
                    ),
                    SizedBox(height: 20),
                    CustomElavatedButton_1(
                      onPressed: () async {
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          await user.sendEmailVerification();
                          CustomSnackBar_2.show(context, 'Email xác thực đã được gửi lại. Vui lòng kiểm tra hộp thư của bạn.');
                        }
                      },
                      text: 'Gửi lại email xác thực',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }