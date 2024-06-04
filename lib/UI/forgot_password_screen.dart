import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/forgot_password_viewmodel.dart';
import '../widget/custom_ElevatedButton_1.dart';
import '../widget/custom_appbar.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ForgotPasswordViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                CustomAppbar(title: 'Quên mật khẩu'),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Đừng lo lắng.\nHãy nhập E-mail của bạn và chúng tôi sẽ gửi cho bạn một mã xác minh tới E-mail của bạn để đặt lại mật khẩu của bạn.',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      TextField(
                        controller: viewModel.emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'E-mail',
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))), // Sử dụng OutlineInputBorder để có khung viền xung quanh
                          suffixText: '@gmail.com',
                          errorText: viewModel.emailError.isNotEmpty ? viewModel.emailError : null,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomElavatedButton_1(
                        text: 'Tiếp tục',
                        onPressed: (){
                          // Logic xác nhận email và chuyển sang màn hình xác minh mã
                          if(viewModel.next()){
                            Navigator.of(context).pushNamed('/verify-code');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}


