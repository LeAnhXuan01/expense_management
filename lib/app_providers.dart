import 'package:expense_management/view_model/change_password_view_model.dart';
import 'package:expense_management/view_model/forgot_password_viewmodel.dart';
import 'package:expense_management/view_model/login_view_model.dart';
import 'package:expense_management/view_model/onboarding_view_model.dart';
import 'package:expense_management/view_model/password_retrieval_viewmodel.dart';
import 'package:expense_management/view_model/register_view_model.dart';
import 'package:expense_management/view_model/reminder_view_model.dart';
import 'package:expense_management/view_model/verify_code_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AppProviders extends StatelessWidget {
  final Widget child;

  AppProviders({required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => VerifyCodeViewModel()),
        ChangeNotifierProvider(create: (_) => PasswordRetrievalViewModel()),
        ChangeNotifierProvider(create: (_) => ChangePasswordViewModel()),
        // ChangeNotifierProvider(create: (context) => ReminderViewModel()),
      ],
      child: child,
    );
  }
}
