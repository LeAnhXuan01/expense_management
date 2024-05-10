import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/forgot_password_viewmodel.dart';
import '../widget/custom_ElevatedButton_1.dart';
import '../widget/custom_appbar.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForgotPasswordViewModel(),
      child: ForgotPassScreenContent(),
    );
  }
}

class ForgotPassScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ForgotPasswordViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                CustomAppbar(title: 'Quên Mật Khẩu'),
                const SizedBox(height: 80,),
                const Text(
                  'Đừng lo lắng.\nHãy nhập email của bạn và chúng tôi sẽ gửi cho bạn một liên kết để đặt lại mật khẩu của bạn.',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => viewModel.setEmail(value),
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))), // Sử dụng OutlineInputBorder để có khung viền xung quanh
                  ),
                ),
                const SizedBox(height: 30),
                CustomElavatedButton_1(
                  text: 'Tiếp tục',
                  onPressed: (){
                    // Logic xác nhận email và chuyển sang màn hình xác minh mã
                    Navigator.of(context).pushNamed('/verify-code');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
