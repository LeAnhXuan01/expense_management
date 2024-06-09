import 'package:expense_management/view/bill/bill_list_screen.dart';
import 'package:expense_management/view/bill/creat_bill_screen.dart';
import 'package:expense_management/view/budget/budget_list_screen.dart';
import 'package:expense_management/view/budget/creat_budget_screen.dart';
import 'package:expense_management/view/category/category_list_screen.dart';
import 'package:expense_management/view/home_screen.dart';
import 'package:expense_management/view/intro/onboarding_screen.dart';
import 'package:expense_management/view/password_retrieval_screen.dart';
import 'package:expense_management/view/statistics/statistics_screen.dart';
import 'package:expense_management/view/transaction/add_transaction_screen.dart';
import 'package:expense_management/view/transaction/creat_categories_screen.dart';
import 'package:expense_management/view/transaction/expense_category_add_screen.dart';
import 'package:expense_management/view/transaction/income_category_add_screen.dart';
import 'package:expense_management/view/transaction/transaction_history/transaction_history_screen.dart';
import 'package:expense_management/view/user/change_password_screen.dart';
import 'package:expense_management/view/user/forgot_password_screen.dart';
import 'package:expense_management/view/user/login_screen.dart';
import 'package:expense_management/view/user/profile_screen.dart';
import 'package:expense_management/view/user/register_screen.dart';
import 'package:expense_management/view/user/verify_email_pass_screen.dart';
import 'package:expense_management/view/user/verify_email_screen.dart';
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
  '/add-transaction': (context) =>  AddTransactionScreen(),
  '/creat-categories': (context) =>  CreatCategoriesScreen(),
  '/income-category-add': (context) =>  IncomeCategoryAddScreen(),
  '/expense-category-add': (context) =>  ExpenseCategoryAddScreen(),
  '/transaction-history': (context) =>  TransactionHistoryScreen(transactions: [],),
  '/profile': (context) =>  ProfileScreen(),
  '/bottom': (context) =>  Bottom(),
  '/wallets': (context) =>  WalletScreen(),
  '/bill-list': (context) =>  BillListScreen(),
  '/creat-bill': (context) =>  CreatBillScreen(),
  '/statistics': (context) =>  StatisticsScreen(),
  '/creat-budget': (context) =>  CreatBudgetScreen(),
  '/budget-list': (context) =>  BudgetListScreen(),
  '/category-list': (context) =>  CategoryListScreen(),
  '/verify-email-pass': (context) =>  VerifyEmailPassScreen(),
  '/verify-email': (context) =>  VerifyEmailScreen(),
};

