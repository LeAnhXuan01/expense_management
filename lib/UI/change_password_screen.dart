import 'package:expense_management/widget/custom_ElevatedButton_1.dart';
import 'package:expense_management/widget/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/change_password_view_model.dart';

class ChangePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<ChangePasswordViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  CustomHeader(title: 'Đổi mật khẩu'),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: viewModel.usernameController,
                          decoration: InputDecoration(
                            labelText: 'Tên đăng nhập',
                            errorText: viewModel.usernameError.isNotEmpty
                                ? viewModel.usernameError
                                : null,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: viewModel.currentPasswordController,
                          obscureText: !viewModel.isCurrentPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu hiện tại',
                            suffixIcon: IconButton(
                              icon: Icon(viewModel.isCurrentPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed:
                                  viewModel.toggleCurrentPasswordVisibility,
                            ),
                            errorText: viewModel.currentPasswordError.isNotEmpty
                                ? viewModel.currentPasswordError
                                : null,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: viewModel.newPasswordController,
                          obscureText: !viewModel.isNewPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu mới',
                            suffixIcon: IconButton(
                              icon: Icon(viewModel.isNewPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: viewModel.toggleNewPasswordVisibility,
                            ),
                            errorText: viewModel.newPasswordError.isNotEmpty
                                ? viewModel.newPasswordError
                                : null,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: viewModel.confirmPasswordController,
                          obscureText: !viewModel.isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Nhập lại mật khẩu mới',
                            suffixIcon: IconButton(
                              icon: Icon(viewModel.isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed:
                                  viewModel.toggleConfirmPasswordVisibility,
                            ),
                            errorText: viewModel.confirmPasswordError.isNotEmpty
                                ? viewModel.confirmPasswordError
                                : null,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text('Mật khẩu mới phải thỏa mãn các điều kiện sau:\n'
                            '- Dài tối thiểu 8 ký tự\n'
                            '- Bao gồm ít nhất 3 trong 4 nhóm ký tự sau:\n'
                            '  + Chữ cái VIẾT HOA (từ A đến Z)\n'
                            '  + Chữ cái viết thường (từ a đến z)\n'
                            '  + Chữ số (từ 0 đến 9)\n'
                            '  + Ký tự đặc biệt (ví dụ ., !, \$, #, %)\n'
                            '- Mật khẩu mới không được đặt trùng với mật khẩu cũ',
                          style: TextStyle(color:Colors.deepPurpleAccent, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 50),
                        CustomElavatedButton_1(
                          onPressed: () {
                            if (viewModel.changePassword()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(
                                      child:
                                          Text('Thay đổi mật khẩu thành công')),
                                ),
                              );
                              Future.delayed(Duration(seconds: 2), () {
                                Navigator.of(context).pop();
                              });
                            }
                          },
                          text: 'Lưu',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
  }
}
