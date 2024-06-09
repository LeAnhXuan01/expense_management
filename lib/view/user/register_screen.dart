import 'package:expense_management/widget/custom_ElevatedButton_1.dart';
import 'package:expense_management/widget/custom_header_1.dart';
import 'package:expense_management/widget/custom_snackbar_2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../view_model/user/register_view_model.dart';


class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Xóa dữ liệu từ các controller mỗi khi màn hình được rebuild
    Provider.of<RegisterViewModel>(context, listen: false)
      ..emailController.clear()
      ..passwordController.clear()
      ..confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<RegisterViewModel>(
          builder: (context, viewModel, child) {
            return Column(
                  children: [
                    CustomHeader_1(title: 'Đăng ký'),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                        controller: viewModel.emailController,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(FontAwesomeIcons.solidEnvelope),
                                          labelText: 'Email',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(20))),
                                          errorText: viewModel.emailError.isNotEmpty ? viewModel.emailError : null,
                                          suffixText: '@gmail.com',
                                        ),
                                      ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: viewModel.passwordController,
                                obscureText: !viewModel.isPasswordVisible,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.lock),
                                  labelText: 'Mật khẩu',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                                  suffixIcon: IconButton(
                                    icon: Icon(viewModel.isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                                    onPressed: viewModel.togglePasswordVisibility,
                                  ),
                                  errorText: viewModel.passwordError.isNotEmpty ? viewModel.passwordError : null,
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: viewModel.confirmPasswordController,
                                obscureText: !viewModel.isConfirmPasswordVisible,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.lock),
                                  labelText: 'Nhập lại mật khẩu',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                                  suffixIcon: IconButton(
                                    icon: Icon(viewModel.isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                                    onPressed: viewModel.toggleConfirmPasswordVisibility,
                                  ),
                                  errorText: viewModel.confirmPasswordError.isNotEmpty ? viewModel.confirmPasswordError : null,
                                ),
                              ),
                              SizedBox(height: 20),
                              CustomElavatedButton_1(
                                onPressed: viewModel.isFormValid
                                    ? () async {
                                  bool isRegistered = await viewModel.register();
                                  if (isRegistered) {
                                    CustomSnackBar_2.show(context, 'Một email xác thực đã được gửi tới địa chỉ email của bạn.');
                                    Navigator.of(context).pushNamed('/verify-email');
                                  }
                                }
                                    : null,
                                text: 'Đăng ký',
                              ),


                              SizedBox(height: 16),
                              Center(
                                child: GestureDetector(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                            text: 'Đã có tài khoản? ',
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
