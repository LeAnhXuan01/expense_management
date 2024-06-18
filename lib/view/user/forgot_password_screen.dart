import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/user/forgot_password_viewmodel.dart';
import '../../widget/custom_ElevatedButton_1.dart';
import '../../widget/custom_header_1.dart';
import '../../widget/custom_snackbar_2.dart';

class ForgotPasswordScreen extends StatefulWidget {

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<ForgotPasswordViewModel>(context, listen: false)
      ..emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ForgotPasswordViewModel>(
        builder: (context, viewModel, child) {
          return Column(
              children: [
                CustomHeader_1(title: 'Quên mật khẩu'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Nhập địa chỉ email của bạn và chúng tôi sẽ gửi cho bạn hướng dẫn đặt lại mật khẩu.',
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: viewModel.emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'E-mail',
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                              suffixText: '@gmail.com',
                              errorText: viewModel.emailError.isNotEmpty ? viewModel.emailError : null,
                            ),
                          ),
                          const SizedBox(height: 30),
                          CustomElavatedButton_1(
                            text: 'Tiếp tục',
                            onPressed: viewModel.enableButton ? () async {
                              if (await viewModel.next(context)) {
                                CustomSnackBar_2.show(context, 'Một email đặt lại mật khẩu đã được gửi tới địa chỉ email của bạn.');
                                await Future.delayed(Duration(seconds: 2));
                                Navigator.pushReplacementNamed(context, '/verify-email-pass');
                              }
                            } : null,
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
