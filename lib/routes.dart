import 'package:expense_management/widget/bottom_navigatorbar.dart';
import 'package:flutter/material.dart';
import 'UI/change_password_screen.dart';
import 'UI/forgot_password_screen.dart';
import 'UI/home_screen.dart';
import 'UI/login_screen.dart';
import 'UI/onboarding_screen.dart';
import 'UI/profile_screen.dart';
import 'UI/register_screen.dart';
import 'UI/transaction/add_transaction_screen.dart';
import 'UI/transaction/catalog_creation_screen.dart';
import 'UI/transaction/component/icon_category_screen.dart';
import 'UI/transaction/expense_category_add_screen.dart';
import 'UI/transaction/income_category_add_screen.dart';
import 'UI/transaction/transaction_history/transaction_history_screen.dart';
import 'UI/verify_code_screen.dart';
import 'UI/verify_phone_number_screen.dart';

Map<String, WidgetBuilder> routes = {
  '/onboarding': (context) => OnboardingScreen(),
  '/login': (context) =>  LoginScreen(),
  '/register': (context) =>  RegisterScreen(),
  '/forgot-pass': (context) =>  ForgotPasswordScreen(),
  '/verify-code': (context) =>  VerifyCodeScreen(),
  '/verify-phone-number': (context) =>  VerifyPhoneNumberScreen(),
  '/change-pass': (context) =>  ChangePasswordScreen(),
  '/home': (context) =>  HomeScreen(),
  '/add-transaction': (context) =>  AddTransactionScreen(),
  '/creat-categories': (context) =>  CreatCategoriesScreen(),
  '/income-category-add': (context) =>  IncomeCategoryAddScreen(),
  '/expense-category-add': (context) =>  ExpenseCategoryAddScreen(),
  '/icon-category': (context) =>  IconCategoryScreen(),
  // '/catalog-color': (context) =>  CatalogColorScreen(colors: [],),
  '/transaction-history': (context) =>  TransactionHistoryScreen(transactions: [],),
  '/profile': (context) =>  ProfileScreen(),
  '/bottom': (context) =>  Bottom(),
};

