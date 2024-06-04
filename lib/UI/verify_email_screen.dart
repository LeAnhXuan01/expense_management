  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
  import '../view_model/register_view_model.dart';
  import '../widget/custom_ElevatedButton_1.dart';

  class VerifyEmailScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Xác thực Email'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Vui lòng kiểm tra email của bạn và nhấp vào liên kết xác thực để hoàn tất quá trình đăng ký.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                CustomElavatedButton_1(
                  onPressed: () async {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await user.reload();
                      if (user.emailVerified) {
                        // Lưu thông tin người dùng vào Firestxore
                        // RegisterViewModel().monitorEmailVerification(user);
                        RegisterViewModel viewModel = Provider.of<RegisterViewModel>(context, listen: false);
                        await viewModel.monitorEmailVerification(user, viewModel.passwordController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đăng ký thành công.'),
                          ),
                        );
                        Navigator.of(context).pushNamed('/login');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Email chưa được xác thực. Vui lòng kiểm tra lại.'),
                          ),
                        );
                      }
                    }
                  },
                  text: 'Tôi đã xác thực',
                ),
                SizedBox(height: 20),
                CustomElavatedButton_1(
                  onPressed: () async {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await user.sendEmailVerification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Email xác thực đã được gửi lại. Vui lòng kiểm tra hộp thư của bạn.'),
                        ),
                      );
                    }
                  },
                  text: 'Gửi lại email xác thực',
                ),
              ],
            ),
          ),
        ),
      );
    }
  }