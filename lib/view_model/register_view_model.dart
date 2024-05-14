import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  String _name = '';
  String _phone = '';
  String _verificationId = '';
  String _password = '';
  String _confirmPassword = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isValid = false;

  String get name => _name;
  String get phone => _phone;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get isValid => _isValid;


  String? get nameError {
    if (_name.isNotEmpty && _name.length > 20) {
      return 'Tên đăng nhập không được quá 20 kí tự';
    } else if (_name.isEmpty) {

    } else if (_name.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      return 'Tên đăng nhập không được có kí tự đặc biệt';
    } else if (_name.trim() != _name) {
      return 'Tên đăng nhập không được có dấu cách';
    }
    return null;
  }

  String? get phoneError {
    if (_phone.isEmpty) {

    } else if (_phone.length != 10) {
      return 'Số điện thoại phải đủ 10 số';
    }
    return null;
  }

  String? get passwordError {
    if (_password.isEmpty) {

    } else if (_password.length < 6) {
      return 'Mật khẩu phải từ 6 kí tự trở lên';
    } else if (_password.length > 20) {
      return 'Mật khẩu không được quá 20 kí tự';
    }
    return null;
  }

  String? get confirmPasswordError {
    if (_confirmPassword.isEmpty) {

    } else if (_confirmPassword != _password) {
      return 'Xác nhận mật khẩu không khớp';
    }
    return null;
  }

  void setName(String value) {
    _name = value.trim(); // remove leading and trailing whitespaces
    validateInputs();
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value.trim(); // remove leading and trailing whitespaces
    validateInputs();
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value.trim(); // remove leading and trailing whitespaces
    validateInputs();
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value.trim(); // remove leading and trailing whitespaces
    validateInputs();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void validateInputs() {
    // Check if all conditions are met for validity
    _isValid =
        // _name.isNotEmpty &&
        _phone.length == 10 &&
        _password.isNotEmpty &&
        _password == _confirmPassword;
        // _name.length <= 20 &&
        // !_name.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]')); // Regex to check for special characters
  }
}
