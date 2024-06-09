import 'package:expense_management/widget/custom_header_1.dart';
import 'package:expense_management/widget/custom_snackbar_2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/user/forgot_password_viewmodel.dart';
import '../../widget/custom_ElevatedButton_1.dart';

class VerifyEmailPassScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ForgotPasswordViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              CustomHeader_1(title: 'Xác thực Email'),
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
                                text: '${viewModel.emailController.text}@gmail.com',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    ' để được hướng dẫn đặt lại mật khẩu của bạn.',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        CustomElavatedButton_1(
                          onPressed: () async {
                            await viewModel.sendVerificationEmail(
                                viewModel.emailController.text.trim() +
                                    '@gmail.com');
                            CustomSnackBar_2.show(context, 'Email xác thực đã được gửi lại. Vui lòng kiểm tra hộp thư của bạn.');
                          },
                          text: 'Gửi lại email xác thực',
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
                                        Navigator.of(context).pushNamed('/login');
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
      ),
    );
  }
}
