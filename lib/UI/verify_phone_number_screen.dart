import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../view_model/verify_phone_number_view_model.dart';
import '../widget/custom_appbar.dart';

class VerifyPhoneNumberScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VerifyPhoneNumberViewModel(),
      child: VerifyPhoneNumberScreenContent(),
    );
  }
}

class VerifyPhoneNumberScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<VerifyPhoneNumberViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              CustomAppbar(title: 'Xác thực OTP'),
              const SizedBox(height: 20),
              const Text(
                'Vui lòng nhập mã OTP được gửi đến số điện thoại của bạn.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              PinCodeTextField(
                appContext: context,
                length: 6,  // Số lượng ô
                obscureText: false,  // Ẩn mã
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,  // Hình dạng ô
                  borderRadius: BorderRadius.circular(5),  // Bán kính bo góc
                  fieldHeight: 50,  // Chiều cao ô
                  fieldWidth: 40,  // Chiều rộng ô
                  selectedColor: Colors.blue,  // Màu khi chọn ô
                  activeColor: Colors.grey,  // Màu ô đang hoạt động
                  inactiveColor: Colors.grey[200],  // Màu ô không hoạt động
                ),
                onCompleted: (value) {
                  // Xử lý khi nhập đủ mã
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Center(child: Text('Đăng ký tài khoản thành công')),
                    duration: Duration(seconds: 2),
                  ));
                  Navigator.of(context).pushNamed('/login');
                },
                onChanged: (value) {
                  // Xử lý khi thay đổi mã
                  viewModel.setVerificationCode(value);
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CountdownTimer(
                    endTime: DateTime.now().add(Duration(seconds: viewModel.remainingTime)).millisecondsSinceEpoch,
                    onEnd: () {
                      // Hết thời gian
                      viewModel.resetRemainingTime();
                    },
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Gửi lại mã
                      viewModel.resetRemainingTime();
                    },
                    child: const Text(
                      'Gửi lại mã',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
