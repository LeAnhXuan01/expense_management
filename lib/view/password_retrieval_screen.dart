import 'package:expense_management/widget/custom_ElevatedButton_1.dart';
import 'package:expense_management/widget/custom_header_1.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../view_model/password_retrieval_viewmodel.dart';

class PasswordRetrievalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<PasswordRetrievalViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  CustomHeader_1(title: 'Đặt lại mật khẩu'),
                  SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: viewModel.newPasswordController,
                          obscureText: !viewModel.isNewPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.lock),
                            labelText: 'Mật khẩu mới',
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                            suffixIcon: IconButton(
                              icon: Icon(viewModel.isNewPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: viewModel.toggleNewPasswordVisibility,
                            ),
                            errorText: viewModel.newPasswordError.isNotEmpty
                                ? viewModel.newPasswordError
                                : null,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: viewModel.confirmPasswordController,
                          obscureText: !viewModel.isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.lock),
                            labelText: 'Nhập lại mật khẩu mới',
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                            suffixIcon: IconButton(
                              icon: Icon(viewModel.isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed:
                              viewModel.toggleConfirmPasswordVisibility,
                            ),
                            errorText: viewModel.confirmPasswordError.isNotEmpty
                                ? viewModel.confirmPasswordError
                                : null,
                          ),
                        ),
                        SizedBox(height: 30),
                        CustomElavatedButton_1(
                          onPressed: () {
                            if (viewModel.changePassword()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(
                                      child:
                                      Text('Đặt lại mật khẩu thành công')),
                                ),
                              );
                              Future.delayed(Duration(seconds: 2), () {
                                Navigator.of(context).pushNamed('/login');
                              });
                            }
                          },
                          text: 'Đặt lại mật khẩu',
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: GestureDetector(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Đã nhớ lại mật khẩu? ',
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
                ],
              ),
            );
          },
        ),
      );

  }
}
