import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../view_model/login_view_model.dart';
import '../widget/custom_ElevatedButton_1.dart';
import '../widget/custom_appbar.dart'; // Import Provider để sử dụng ViewModel


class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(), // Cung cấp ViewModel cho màn hình
      child: LoginScreenContent(),
    );
  }
}

class LoginScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                CustomAppbar(title: 'Đăng Nhập',),
                SizedBox(height: 80,),
                TextField(
                  keyboardType: TextInputType.name,
                  onChanged: (value) => viewModel.setName(value), // Cập nhật tên
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: 'Số điện thoại',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      )
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  obscureText: viewModel.obscurePassword,
                  onChanged: (value) => viewModel.setPassword(value), // Cập nhật mật khẩu
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Mật khẩu',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      suffixIcon: IconButton(
                        onPressed: (){
                          viewModel.togglePasswordVisibility(); // Chuyển đổi trạng thái hiển thị mật khẩu
                        },
                        icon: Icon(
                          viewModel.obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                      )
                  ),
                ),
                SizedBox(height: 30),
                CustomElavatedButton_1(
                  text: 'Đăng nhập',
                  onPressed: (){
                    Navigator.of(context).pushNamed('/bottom');
                  },
                ),
                SizedBox(height: 10),
                Center(child: Text('Hoặc', style: TextStyle(color: Colors.grey))),
                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pushNamed('/bottom');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/google.png', width: 24, height: 24,),
                      SizedBox(width: 20),
                      Text(
                        'Đăng nhập với Google',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    fixedSize: Size(360, 50),
                  ),
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
                          color: Colors.deepPurpleAccent,
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
                                color: Colors.deepPurpleAccent,
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
        ),
      ),
    );
  }
}
