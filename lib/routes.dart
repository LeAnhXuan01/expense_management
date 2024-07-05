import 'package:expense_management/view/bill/bill_list_screen.dart';
import 'package:expense_management/view/bill/creat_bill_screen.dart';
import 'package:expense_management/view/budget/budget_list_screen.dart';
import 'package:expense_management/view/budget/create_budget_screen.dart';
import 'package:expense_management/view/category/category_list_screen.dart';
import 'package:expense_management/view/home_screen.dart';
import 'package:expense_management/view/intro/onboarding_screen.dart';
import 'package:expense_management/view/password_retrieval_screen.dart';
import 'package:expense_management/view/statistics/statistics_screen.dart';
import 'package:expense_management/view/category/create_categories_screen.dart';
import 'package:expense_management/view/transaction/component/expense_category_screen.dart';
import 'package:expense_management/view/transaction/component/income_category_screen.dart';
import 'package:expense_management/view/transaction/transaction_history_screen.dart';
import 'package:expense_management/view/user/change_password_screen.dart';
import 'package:expense_management/view/user/edit_profile_screen.dart';
import 'package:expense_management/view/user/forgot_password_screen.dart';
import 'package:expense_management/view/user/login_screen.dart';
import 'package:expense_management/view/user/profile_screen.dart';
import 'package:expense_management/view/user/register_screen.dart';
import 'package:expense_management/view/user/verify_email_pass_screen.dart';
import 'package:expense_management/view/user/verify_email_screen.dart';
import 'package:expense_management/view/transfer/create_transfer_screen.dart';
import 'package:expense_management/view/wallet/create_wallet_screen.dart';
import 'package:expense_management/view/transfer/transfer_history_screen.dart';
import 'package:expense_management/view/wallet/wallets_screen.dart';
import 'package:expense_management/widget/bottom_navigatorbar.dart';
import 'package:flutter/material.dart';


Map<String, WidgetBuilder> routes = {
  '/onboarding': (context) => OnboardingScreen(),
  '/login': (context) =>  LoginScreen(),
  '/register': (context) =>  RegisterScreen(),
  '/forgot-pass': (context) =>  ForgotPasswordScreen(),
  '/password-retrieval': (context) =>  PasswordRetrievalScreen(),
  '/change-password': (context) =>  ChangePasswordScreen(),
  '/home': (context) =>  HomeScreen(),
  '/create-categories': (context) =>  CreateCategoriesScreen(),
  '/income-category': (context) =>  IncomeCategoryScreen(),
  '/expense-category': (context) =>  ExpenseCategoryScreen(),
  '/transaction-history': (context) =>  TransactionHistoryScreen(),
  '/profile': (context) =>  ProfileScreen(),
  '/bottom-navigator': (context) =>  BottomNavigation(),
  '/wallets': (context) =>  WalletScreen(),
  '/bill-list': (context) =>  BillListScreen(),
  '/create-bill': (context) =>  CreatBillScreen(),
  '/create-budget': (context) =>  CreateBudgetScreen(),
  '/budget-list': (context) =>  BudgetListScreen(),
  '/category-list': (context) =>  CategoryListScreen(),
  '/verify-email-pass': (context) =>  VerifyEmailPassScreen(),
  '/verify-email': (context) =>  VerifyEmailScreen(),
  '/edit-profile': (context) =>  EditProfileScreen(),
  '/create-wallet': (context) =>  CreateWalletScreen(),
  '/create-transfer': (context) =>  CreateTransferScreen(),
  '/transfer-history': (context) =>  TransferHistoryScreen(),
};

