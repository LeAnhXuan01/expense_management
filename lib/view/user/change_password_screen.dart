import 'package:expense_management/widget/custom_ElevatedButton_1.dart';
import 'package:expense_management/widget/custom_header_1.dart';
import 'package:expense_management/widget/custom_snackbar_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/user/change_password_view_model.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<ChangePasswordViewModel>(context, listen: false).resetFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ChangePasswordViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              CustomHeader_1(title: 'Đổi mật khẩu'),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          height: 30,
                        ),
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
                        CustomElavatedButton_1(
                          onPressed: viewModel.enableButton
                              ? () async {
                                  if (await viewModel.changePassword(context)) {
                                    await CustomSnackBar_2.show(
                                        context, 'Đổi mật khẩu thành công');
                                    Navigator.pop(context);
                                  }
                                }
                              : null,
                          text: 'Lưu',
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
