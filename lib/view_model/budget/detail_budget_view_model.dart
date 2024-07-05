import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/model/transaction_model.dart';
import 'package:expense_management/services/transaction_service.dart';
import 'package:expense_management/services/category_service.dart';
import 'package:expense_management/services/wallet_service.dart';
import 'package:intl/intl.dart';
import '../../model/budget_model.dart';
import '../../model/category_model.dart';
import '../../model/enum.dart';
import '../../model/wallet_model.dart';

class DetailBudgetViewModel with ChangeNotifier {
  final TransactionService _transactionService = TransactionService();
  final CategoryService _categoryService = CategoryService();
  final WalletService _walletService = WalletService();
  final Budget budget;

  List<Transactions> transactions = [];
  Map<String, Wallet> walletMap = {};
  Map<String, Category> categoryMap = {};
  List<Transactions> filteredTransactions = [];
  Map<String, List<Transactions>> groupedTransactions = {};
  bool showTransactions = false;

  void toggleShowTransactions() {
    showTransactions = !showTransactions;
    notifyListeners();
  }

  double _totalExpenditure = 0.0;
  double get totalExpenditure => _totalExpenditure;

  double _actualSpending = 0.0;
  double get actualSpending => _actualSpending;

  double _recommendedSpending = 0.0;
  double get recommendedSpending => _recommendedSpending;

  double _projectedSpending = 0.0;
  double get projectedSpending => _projectedSpending;

  DetailBudgetViewModel(this.budget) {
    loadData();
  }

  Future<void> loadData() async {
    await Future.wait([
      loadTransactions(),
      loadWallets(),
      loadCategories(),
    ]);
    filterTransactionsByBudget();
    filterTransactionsBySelectedWallets();
    groupTransactions();
    calculateExpenditures();
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        transactions = await _transactionService.getTransaction(user.uid);
      } catch (e) {
        print("Error loading transactions: $e");
      }
    }
  }

  Future<void> loadWallets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        List<Wallet> wallets = await _walletService.getWallets(user.uid);
        walletMap = {for (var wallet in wallets) wallet.walletId: wallet};
      } catch (e) {
        print("Error loading wallets: $e");
      }
    }
  }

  Future<void> loadCategories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        List<Category> categories = await _categoryService.getAllCategories(user.uid);
        List<String> selectedCategoryIds = budget.categoryId;
        categoryMap = {
          for (var category in categories)
            if (selectedCategoryIds.contains(category.categoryId)) category.categoryId: category
        };
      } catch (e) {
        print("Error loading categories: $e");
      }
    }
  }

  // void filterTransactionsByBudget() {
  //   filteredTransactions = transactions.where((transaction) {
  //     return budget.categoryId.contains(transaction.categoryId);
  //   }).toList();
  // }

  void filterTransactionsByBudget() {
    filteredTransactions = transactions.where((transaction) {
      // Lọc các giao dịch theo danh mục và khoảng thời gian của hạn mức
      return budget.categoryId.contains(transaction.categoryId) &&
          transaction.date.isAfter(budget.startDate) &&
          transaction.date.isBefore(budget.endDate);
    }).toList();
  }

  void filterTransactionsBySelectedWallets() {
    filteredTransactions = filteredTransactions.where((transaction) {
      return budget.walletId.contains(transaction.walletId);
    }).toList();
  }

  void filterTransactionsByDateRange() {
    filteredTransactions = filteredTransactions.where((transaction) {
      return transaction.date.isAfter(budget.startDate) &&
          transaction.date.isBefore(budget.endDate.add(Duration(days: 1)));
    }).toList();
  }

  void groupTransactions() {
    groupedTransactions = {};
    for (var transaction in filteredTransactions) {
      final date = DateFormat('dd/MM/yyyy').format(transaction.date);
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }
  }

  void calculateExpenditures() {
    const double usdToVndRate = 25442.5;

    // Tính tổng chi tiêu, bao gồm chuyển đổi USD sang VND
    _totalExpenditure = filteredTransactions.fold(0, (sum, transaction) {
      double amountInVnd = transaction.currency == Currency.USD ? transaction.amount * usdToVndRate : transaction.amount;
      return sum + amountInVnd;
    });

    // Tính số ngày chi tiêu (bao gồm ngày đầu tiên)
    int spendingDays = filteredTransactions.isNotEmpty ? DateTime.now().difference(filteredTransactions.first.date).inDays + 1 : 1;

    // Thực tế chi tiêu
    _actualSpending = _totalExpenditure / spendingDays;

    // Tính số ngày còn lại
    int remainingDays = budget.endDate.difference(DateTime.now()).inDays;

    // Tính số tiền còn lại của hạn mức
    double remainingBudget = budget.amount > _totalExpenditure ? budget.amount - _totalExpenditure : 0;

    // Tính chi tiêu đề xuất
    _recommendedSpending = (remainingDays > 0 && remainingBudget > 0) ? remainingBudget / remainingDays : 0;

    // Tính chi tiêu dự kiến
    _projectedSpending = _actualSpending * remainingDays + _totalExpenditure;

    notifyListeners();
  }



}

