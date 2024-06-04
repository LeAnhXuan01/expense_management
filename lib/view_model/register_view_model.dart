  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/cupertino.dart';

  class RegisterViewModel extends ChangeNotifier {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    bool isPasswordVisible = false;
    bool isPasswordChanged = false;
    bool isConfirmPasswordVisible = false;

    String emailError = '';
    String passwordError = '';
    String confirmPasswordError = '';

    RegisterViewModel() {
      emailController.addListener(() {
        if (validateEmail(emailController.text)) {
          emailError = '';
          notifyListeners();
        }
      });
      passwordController.addListener(() {
        if (validatePassword(passwordController.text)) {
          passwordError = '';
          notifyListeners();
        }
      });
      confirmPasswordController.addListener(() {
        if (confirmPasswordController.text == passwordController.text) {
          confirmPasswordError = '';
          notifyListeners();
        }
      });
    }

    void togglePasswordVisibility() {
      isPasswordVisible = !isPasswordVisible;
      notifyListeners();
    }

    void toggleConfirmPasswordVisibility() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
      notifyListeners();
    }

    void togglePasswordChanged() {
      isPasswordChanged = true;
      notifyListeners();
    }

    bool validateEmail(String email) {
      if (email.isEmpty) {
        emailError = 'Vui lòng nhập email.';
        return false;
      }
      if (email.contains('@gmail.com')) {
        emailError = 'Không cần nhập đuôi @gmail.com.';
        return false;
      }
      if (email.contains(RegExp(r'[!#$%^&*(),?":{}|<>]'))) {
        emailError = 'Email không được chứa ký tự đặc biệt.';
        return false;
      }
      emailError = '';
      return true;
    }

    bool validatePassword(String password) {
      if(isPasswordChanged){
        if (password.isEmpty) {
          passwordError = 'Vui lòng nhập mật khẩu.';
          return false;
        }
        if (password.length < 8) {
          passwordError = 'Mật khẩu phải dài tối thiểu 8 ký tự.';
          return false;
        }
        if (password.length > 30) {
          passwordError = 'Mật khẩu dài không vượt quá 30 ký tự.';
          return false;
        }
        int criteriaCount = 0;
        if (password.contains(RegExp(r'[A-Z]'))) criteriaCount++;
        if (password.contains(RegExp(r'[a-z]'))) criteriaCount++;
        if (password.contains(RegExp(r'[0-9]'))) criteriaCount++;
        if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) criteriaCount++;

        if (criteriaCount < 3) {
          passwordError = 'Mật khẩu phải bao gồm ít nhất 3 trong 4 nhóm ký tự sau:\n- Chữ cái VIẾT HOA\n- Chữ cái viết thường\n- Chữ số\n- Ký tự đặc biệt';
          return false;
        }
      }
      passwordError = '';
      return true;
    }

    Future<bool> register() async {
      final email = emailController.text;
      final newPassword = passwordController.text;
      final confirmPassword = confirmPasswordController.text;

      if (!validateEmail(email) ||
          !validatePassword(newPassword) ||
          newPassword != confirmPassword) {
        if (newPassword != confirmPassword) {
          confirmPasswordError = 'Mật khẩu và xác nhận mật khẩu không khớp.';
        }
        notifyListeners();
        return false;
      }

      try {
        // Tạo tài khoản mới với Firebase Authentication
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email + '@gmail.com',
          password: newPassword,
        );

        // Gửi email xác thực
        await userCredential.user!.sendEmailVerification();

        // Chờ người dùng xác thực email
        // Gọi monitorEmailVerification sau khi đăng ký thành công
        // bool isVerified = await monitorEmailVerification(userCredential.user!);
        //
        // return isVerified;
        return true;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          emailError = 'Email này đã được sử dụng.';
        } else if (e.code == 'invalid-email') {
          emailError = 'Email không hợp lệ.';
        } else if (e.code == 'weak-password') {
          passwordError = 'Mật khẩu quá yếu.';
        }
        notifyListeners();
        return false;
      } catch (e) {
        print(e);
        return false;
      }
    }

    Future<bool> monitorEmailVerification(User user, String password) async {
      await user.reload();
      if (user.emailVerified) {
        // Lấy user ID từ Firebase Authentication
        String userId = user.uid;

        // Lưu thông tin người dùng vào Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'userId': userId,
          'email': user.email,
          'password': password,
        });

        return true;
      } else {
        return false;
      }
    }
  }