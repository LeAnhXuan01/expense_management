import 'package:flutter/material.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  String usernameError = '';
  String currentPasswordError = '';
  String newPasswordError = '';
  String confirmPasswordError = '';

  ChangePasswordViewModel() {
    usernameController.addListener(() {
      if (usernameController.text.isNotEmpty) {
        usernameError = '';
        notifyListeners();
      }
    });
    currentPasswordController.addListener(() {
      if (currentPasswordController.text.isNotEmpty) {
        currentPasswordError = '';
        notifyListeners();
      }
    });
    newPasswordController.addListener(() {
      if (validateNewPassword(newPasswordController.text, currentPasswordController.text)) {
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

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible = !isCurrentPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible = !isNewPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  bool validateNewPassword(String newPassword, String currentPassword) {
    if (newPassword.length < 8) {
      newPasswordError = 'Mật khẩu mới phải dài tối thiểu 8 ký tự.';
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

    if (newPassword == currentPassword) {
      newPasswordError = 'Mật khẩu mới không được đặt trùng với mật khẩu cũ.';
      return false;
    }

    newPasswordError = '';
    return true;
  }

  bool changePassword() {
    final username = usernameController.text;
    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    usernameError = '';
    currentPasswordError = '';
    newPasswordError = '';
    confirmPasswordError = '';

    if (username.isEmpty) {
      usernameError = 'Vui lòng nhập tên đăng nhập.';
    }
    if (currentPassword.isEmpty) {
      currentPasswordError = 'Vui lòng nhập mật khẩu hiện tại.';
    }
    if (newPassword.isEmpty) {
      newPasswordError = 'Vui lòng nhập mật khẩu mới.';
    }
    if (confirmPassword.isEmpty) {
      confirmPasswordError = 'Vui lòng nhập lại mật khẩu mới.';
    }

    if (usernameError.isNotEmpty || currentPasswordError.isNotEmpty || newPasswordError.isNotEmpty || confirmPasswordError.isNotEmpty) {
      notifyListeners();
      return false;
    }

    if (!validateNewPassword(newPassword, currentPassword)) {
      notifyListeners();
      return false;
    }

    if (newPassword != confirmPassword) {
      confirmPasswordError = 'Mật khẩu mới và xác nhận mật khẩu mới không khớp.';
      notifyListeners();
      return false;
    }

    // Thay đổi mật khẩu thành công
    return true;
  }
}

