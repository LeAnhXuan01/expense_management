import 'package:flutter/material.dart';

class PasswordRetrievalViewModel extends ChangeNotifier {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  String newPasswordError = '';
  String confirmPasswordError = '';

  PasswordRetrievalViewModel() {
    newPasswordController.addListener(() {
      if (validateNewPassword(newPasswordController.text)) {
        newPasswordError = '';
        notifyListeners();
      }
    });
    confirmPasswordController.addListener(() {
      if (confirmPasswordController.text == newPasswordController.text) {
        confirmPasswordError = '';
        notifyListeners();
      }
    });
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible = !isNewPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  bool validateNewPassword(String newPassword) {
    if (newPassword.isEmpty) {
      newPasswordError = 'Vui lòng nhập mật khẩu mới.';
      return false;
    }
    if (newPassword.length < 8) {
      newPasswordError = 'Mật khẩu mới phải dài tối thiểu 8 ký tự.';
      return false;
    }
    if (newPassword.length > 30) {
      newPasswordError = 'Mật khẩu mới dài không vượt quá 30 ký tự.';
      return false;
    }

    int criteriaCount = 0;
    if (newPassword.contains(RegExp(r'[A-Z]'))) criteriaCount++;
    if (newPassword.contains(RegExp(r'[a-z]'))) criteriaCount++;
    if (newPassword.contains(RegExp(r'[0-9]'))) criteriaCount++;
    if (newPassword.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) criteriaCount++;

    if (criteriaCount < 3) {
      newPasswordError = 'Mật khẩu mới phải bao gồm ít nhất 3 trong 4 nhóm ký tự sau:\n- Chữ cái VIẾT HOA\n- Chữ cái viết thường\n- Chữ số\n- Ký tự đặc biệt';
      return false;
    }

    newPasswordError = '';
    return true;
  }

  bool changePassword() {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    newPasswordError = '';
    confirmPasswordError = '';

    if (newPasswordError.isNotEmpty || confirmPasswordError.isNotEmpty) {
      notifyListeners();
      return false;
    }

    if (!validateNewPassword(newPassword)) {
      notifyListeners();
      return false;
    }

    if (newPassword != confirmPassword) {
      confirmPasswordError = 'Mật khẩu mới và xác nhận mật khẩu mới không khớp.';
      notifyListeners();
      return false;
    }

    return true;
  }
}

