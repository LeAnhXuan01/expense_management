import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../view_model/user/login_view_model.dart';
import '../../widget/custom_ElevatedButton_1.dart';
import '../../widget/custom_header_2.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Xóa dữ liệu từ các controller mỗi khi màn hình được rebuild
    Provider.of<LoginViewModel>(context, listen: false)
      ..emailController.clear()
      ..passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginViewModel>(builder: (context, viewModel, child) {
        return SingleChildScrollView(
            child: Column(
          children: [
            CustomHeader_2(title: 'Đăng Nhập'),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                      child: Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                    width: 150,
                  )),
                  SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: viewModel.emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.solidEnvelope),
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20))
                      ),
                      suffixText: '@gmail.com',
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: viewModel.passwordController,
                    obscureText: !viewModel.isPasswordVisible,
                    // onChanged: (value) => viewModel.setPassword(value),
                    // Cập nhật mật khẩu
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Mật khẩu',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            viewModel
                                .togglePasswordVisibility(); // Chuyển đổi trạng thái hiển thị mật khẩu
                          },
                          icon: Icon(
                            viewModel.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        )),
                  ),
                  SizedBox(height: 30),
                  CustomElavatedButton_1(
                    text: 'Đăng nhập',
                    onPressed: viewModel.isFormValid ? () async {
                      if (await viewModel.login(context)) {
                        Navigator.pushReplacementNamed(context, '/bottom');
                      }
                    } : null, // Chuyển sang null khi form không hợp lệ
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/forgot-pass');
                      },
                      child: const Text(
                        'Quên mật khẩu?',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                                text: 'Vẫn chưa có tài khoản? ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                )),
                            TextSpan(
                              text: 'Đăng ký',
                              style: const TextStyle(
                                  color: Colors.green,
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushNamed('/register');
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
        ));
      }),
    );
  }
}
