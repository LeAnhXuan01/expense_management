import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../view_model/register_view_model.dart';
import '../widget/custom_ElevatedButton_1.dart';
import '../widget/custom_appbar.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterViewModel(),
      child: RegisterScreenContent(),
    );
  }
}

class RegisterScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                CustomAppbar(title: 'Đăng Ký'),
                const SizedBox(height: 80),
                // TextField(
                //   keyboardType: TextInputType.name,
                //   onChanged: (value) => viewModel.setName(value),
                //   decoration: InputDecoration(
                //     labelText: 'Tên đăng nhập',
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(20)),
                //     ),
                //     errorText: viewModel.nameError,
                //   ),
                // ),
                // SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) => viewModel.setPhone(value),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    errorText: viewModel.phoneError,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: viewModel.obscurePassword,
                  onChanged: (value) => viewModel.setPassword(value),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Mật khẩu',
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    suffixIcon: IconButton(
                      onPressed: () {
                        viewModel.togglePasswordVisibility();
                      },
                      icon: Icon(
                        viewModel.obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    errorText: viewModel.passwordError,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: viewModel.obscureConfirmPassword,
                  onChanged: (value) => viewModel.setConfirmPassword(value),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Xác nhận mật khẩu',
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    suffixIcon: IconButton(
                      onPressed: () {
                        viewModel.toggleConfirmPasswordVisibility();
                      },
                      icon: Icon(
                        viewModel.obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    errorText: viewModel.confirmPasswordError,
                  ),
                ),
                const SizedBox(height: 30),
                CustomElavatedButton_1(
                  text: 'Đăng ký',
                  onPressed: viewModel.isValid
                      ? () {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Center(child: Text('Đăng ký thành công')))
                    // );
                    Navigator.of(context).pushNamed('/verify-phone-number');
                    // Gửi mã OTP khi người dùng nhấn nút đăng ký

                  }
                      : null, // Disable button if not valid
                ),
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                              text: 'Đã có một tài khoản? ',
                              style: TextStyle(color: Colors.black, fontSize: 15)),
                          TextSpan(
                            text: 'Đăng nhập',
                            style: const TextStyle(
                              color: Colors.deepPurpleAccent,
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
    );
  }
}
