import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool hasCurrentPassword = false;
  bool hasNewPassword = false;
  bool hasConfirmPassword = false;
  bool enableButton = false;

  String currentPasswordError = '';
  String newPasswordError = '';
  String confirmPasswordError = '';

  ChangePasswordViewModel() {
    currentPasswordController.addListener(() {
      validateCurrenPassword(currentPasswordController.text);
    });
    newPasswordController.addListener(() {
      validateNewPassword(newPasswordController.text, currentPasswordController.text);
    });
    confirmPasswordController.addListener(() {
      validateConfirmPassword(confirmPasswordController.text, newPasswordController.text);
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

  void validateCurrenPassword(String currentPassword) {
    if (currentPassword.length < 6 && currentPasswordController.text.isNotEmpty) {
      currentPasswordError = 'Mật khẩu cũ phải dài ít nhất 6 ký tự.';
      hasCurrentPassword = true;
    } else if (currentPassword.length > 30 && currentPasswordController.text.isNotEmpty) {
      currentPasswordError = 'Mật khẩu cũ dài không quá 30 ký tự.';
      hasCurrentPassword = true;
    } else {
      currentPasswordError = '';
      hasCurrentPassword = false;
    }
    validateForm();
  }

  void validateNewPassword(String newPassword, String currentPassword) {
    if (newPassword.length < 6 && newPasswordController.text.isNotEmpty) {
      newPasswordError = 'Mật khẩu mới phải dài ít nhất 6 ký tự.';
      hasNewPassword = true;
    } else if (newPassword.length > 30 && newPasswordController.text.isNotEmpty) {
      newPasswordError = 'Mật khẩu mới dài không quá 30 ký tự.';
      hasNewPassword = true;
    } else if (newPassword == currentPassword && confirmPasswordController.text.isNotEmpty) {
      newPasswordError = 'Mật khẩu mới không được đặt trùng với mật khẩu cũ.';
      hasNewPassword = true;
    } else{
      newPasswordError = "";
      hasNewPassword = false;
    }
    validateForm();
  }

  void validateConfirmPassword(String confirmPassword, String newPassword) {
    if (confirmPassword != newPassword) {
      confirmPasswordError = 'Mật khẩu và xác nhận mật khẩu không khớp.';
      hasConfirmPassword = true;
    } else {
      confirmPasswordError = '';
      hasConfirmPassword = false;
    }
    validateForm();
  }

  void validateForm() {
    enableButton = currentPasswordController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        !hasCurrentPassword &&
        !hasNewPassword &&
        !hasConfirmPassword;
    notifyListeners();
  }

  void resetFields() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    enableButton = false;
    isCurrentPasswordVisible = false;
    isNewPasswordVisible = false;
    isConfirmPasswordVisible = false;
    notifyListeners();
  }

  Future<bool> changePassword(BuildContext context) async {
    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;

    final isCurrentPasswordValid = !hasCurrentPassword;
    final isNewPasswordValid = !hasNewPassword;
    final isConfirmPasswordValid = !hasConfirmPassword;

    if (!isCurrentPasswordValid || !isNewPasswordValid || !isConfirmPasswordValid) {
      notifyListeners();
      return false;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Xác thực mật khẩu hiện tại
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        // Cập nhật mật khẩu mới
        await user.updatePassword(newPassword);
        // Cập nhật mật khẩu mới vào Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'password': newPassword,
        });
        notifyListeners();
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        currentPasswordError = 'Mật khẩu hiện tại không đúng.';
      } else {
        currentPasswordError = 'Đã xảy ra lỗi. Vui lòng thử lại.';
        print('Error change password: $e');
      }
      notifyListeners();
    } catch (e) {
      currentPasswordError = 'Đã xảy ra lỗi. Vui lòng thử lại sau.';
      print('Error change password: $e');
      notifyListeners();
    }
    return false;
  }
}

