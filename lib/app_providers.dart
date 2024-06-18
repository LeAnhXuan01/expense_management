import 'package:expense_management/view_model/category/category_list_view_model.dart';
import 'package:expense_management/view_model/category/creat_categories_view_model.dart';
import 'package:expense_management/view_model/category/edit_category_view_model.dart';
import 'package:expense_management/view_model/home/home_view_model.dart';
import 'package:expense_management/view_model/transfer/edit_transfer_view_model.dart';
import 'package:expense_management/view_model/transfer/transfer_history_view_model.dart';
import 'package:expense_management/view_model/user/change_password_view_model.dart';
import 'package:expense_management/view_model/user/edit_profile_view_model.dart';
import 'package:expense_management/view_model/user/forgot_password_viewmodel.dart';
import 'package:expense_management/view_model/user/login_view_model.dart';
import 'package:expense_management/view_model/intro/onboarding_view_model.dart';
import 'package:expense_management/view_model/password_retrieval_viewmodel.dart';
import 'package:expense_management/view_model/user/register_view_model.dart';
import 'package:expense_management/view_model/wallet/create_wallet_view_model.dart';
import 'package:expense_management/view_model/wallet/edit_wallet_view_model.dart';
import 'package:expense_management/view_model/wallet/wallet_view_model.dart';
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
        ChangeNotifierProvider(create: (_) => PasswordRetrievalViewModel()),
        ChangeNotifierProvider(create: (_) => ChangePasswordViewModel()),
        ChangeNotifierProvider(create: (_) => EditProfileViewModel()),
        ChangeNotifierProvider(create: (_) => CreatCategoriesViewModel()),
        ChangeNotifierProvider(create: (_) => EditCategoriesViewModel()),
        ChangeNotifierProvider(create: (_) => CreateWalletViewModel()),
        ChangeNotifierProvider(create: (_) => EditWalletViewModel()),
        ChangeNotifierProvider(create: (_) => TransferHistoryViewModel()),
        ChangeNotifierProvider(create: (_) => EditTransferViewModel()),
        ChangeNotifierProvider(create: (_) => WalletViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryListViewModel()),
      ],
      child: child,
    );
  }
}
