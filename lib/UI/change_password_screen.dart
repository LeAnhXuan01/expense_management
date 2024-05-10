import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/change_password_viewmodel.dart';
import '../widget/custom_ElevatedButton_1.dart';
import '../widget/custom_appbar.dart';

class ChangePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChangePasswordViewModel(),
      child: ChangePassScreenContent(),
    );
  }
}

class ChangePassScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChangePasswordViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              CustomAppbar(title: 'Đổi Mật Khẩu'),
              const SizedBox(height: 80),
              TextField(
                obscureText: viewModel.obscurePassword,
                onChanged: (value) => viewModel.setNewPassword(value),
                decoration: InputDecoration(
                  labelText: 'Mật khẩu mới',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  suffixIcon: IconButton(
                    onPressed: () {
                      viewModel.togglePasswordVisibility();
                    },
                    icon: Icon(
                      viewModel.obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: viewModel.obscurePassword,
                onChanged: (value) => viewModel.setConfirmPassword(value),
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu mới',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  suffixIcon: IconButton(
                    onPressed: () {
                      viewModel.togglePasswordVisibility();
                    },
                    icon: Icon(
                      viewModel.obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CustomElavatedButton_1(
                  text: 'Tiếp tục',
                  onPressed: (){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Center(child: Text('Thay đổi mật khẩu thành công')),
                      duration: Duration(seconds: 2),
                    ));
                    // Hiển thị giao diện thay đổi mật khẩu
                    Navigator.of(context).pushNamed('/login');}
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
