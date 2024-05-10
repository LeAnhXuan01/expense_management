import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
                TextField(
                  keyboardType: TextInputType.name,
                  onChanged: (value) => viewModel.setName(value),
                  decoration: InputDecoration(
                      labelText: 'Tên',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      )
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => viewModel.setEmail(value),
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: viewModel.obscurePassword,
                  onChanged: (value) => viewModel.setPassword(value),
                  decoration: InputDecoration(
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
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: viewModel.obscureConfirmPassword,
                  onChanged: (value) => viewModel.setConfirmPassword(value),
                  decoration: InputDecoration(
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
                  ),
                ),
                const SizedBox(height: 30),
                CustomElavatedButton_1(
                  text: 'Đăng ký',
                  onPressed: (){
                    Navigator.of(context).pushNamed('/login');
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                              text: 'Đã có một tài khoản? ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15
                              )
                          ),
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
