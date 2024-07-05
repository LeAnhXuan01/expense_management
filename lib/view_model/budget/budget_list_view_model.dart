import 'package:expense_management/services/category_service.dart';
import 'package:expense_management/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/budget_model.dart';
import '../../model/category_model.dart';
import '../../model/enum.dart';
import '../../model/transaction_model.dart';
import '../../model/wallet_model.dart';
import '../../services/budget_service.dart';
import '../../services/transaction_service.dart';

class BudgetListViewModel extends ChangeNotifier {
  final TransactionService _transactionService = TransactionService();
  final BudgetService _budgetService = BudgetService();
  final WalletService _walletService = WalletService();
  final CategoryService _categoryService = CategoryService();
  TextEditingController searchController = TextEditingController();

  List<Budget> _budgets = [];
  List<Budget> _filteredbudgets = [];
  bool isSearching = false;
  String searchQuery = "";
  Map<String, Category> categoryMap = {};
  Map<String, Wallet> walletMap = {};

  List<Budget> get budgets => _filteredbudgets;

  BudgetListViewModel() {
    loadData();
  }

  Future<void> loadData() async {
    loadBudgets();
    loadCategories();
    loadWallets();
  }

  Future<void> loadBudgets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try{
        _budgets = await _budgetService.getBudgets(user.uid);
        _filteredbudgets = _budgets;
        notifyListeners();
      } catch (e){
        print("Error loading budgets: $e");
      }
    }
  }

  void filterBudgets(String query) {
    if (query.isEmpty) {
      _filteredbudgets = _budgets;
    } else {
      _filteredbudgets = _budgets.where((bugdet) {
        return bugdet.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> loadCategories() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try{
        List<Category> categories = await _categoryService.getExpenseCategories(user.uid);
        categoryMap = {for (var category in categories) category.categoryId: category};
        notifyListeners();
      } catch (e){
        print("Error loading categories: $e");
      }
    }
  }

  Future<void> loadWallets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try{
        List<Wallet> wallets = await _walletService.getWallets(user.uid);
        walletMap = {for (var wallet in wallets) wallet.walletId: wallet};
        notifyListeners();
      } catch (e){
        print("Error loading wallets: $e");
      }
    }
  }

  Future<void> deleteBudget(String budgetId) async {
    try {
      await _budgetService.deleteBudget(budgetId);
      _budgets.removeWhere((budget) => budget.budgetId == budgetId);
      notifyListeners();
    } catch (e) {
      print('Error deleting budget: $e');
    }
  }

  Category? getCategoryById(String categoryId) {
    return categoryMap[categoryId];
  }

  Wallet? getWalletById(String walletId) {
    return walletMap[walletId];
  }

  String getCategoriesText(List<String> selectedCategories) {
    if (selectedCategories.isEmpty ||
        selectedCategories.length == categoryMap.length) {
      return 'Tất cả danh mục chi tiêu';
    }
    if (selectedCategories.length == 1) {
      return categoryMap[selectedCategories[0]]?.name ?? '';
    }
    if (selectedCategories.length == 2) {
      return '${categoryMap[selectedCategories[0]]?.name ?? ''}, ${categoryMap[selectedCategories[1]]?.name ?? ''}';
    }
    return '${categoryMap[selectedCategories[0]]?.name ?? ''}, ${categoryMap[selectedCategories[1]]?.name ?? ''} + ${selectedCategories.length - 2} danh mục khác';
  }

  String getWalletsText(List<String> selectedWallets) {
    if (selectedWallets.length == 0 ||
        selectedWallets.length == walletMap.length) return 'Tất cả ví';
    if (selectedWallets.length == 1)
      return walletMap[selectedWallets[0]]?.name ?? '';
    if (selectedWallets.length == 2)
      return '${walletMap[selectedWallets[0]]?.name ?? ''}, ${walletMap[selectedWallets[1]]?.name ?? ''}';
    return '${walletMap[selectedWallets[0]]?.name ?? ''}, ${walletMap[selectedWallets[1]]?.name ?? ''} + ${selectedWallets.length - 2} ví tiền';
  }

  Future<double> calculateSpentAmount(
      List<String> categoryIds, List<String> walletIds) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<Transactions> transactions =
          await _transactionService.getTransaction(user.uid);
      double totalSpent = 0.0;
      const double exchangeRate = 25442.5;

      for (var transaction in transactions) {
        if (categoryIds.contains(transaction.categoryId) &&
            walletIds.contains(transaction.walletId)) {
          double amountInVND = transaction.amount;
          if (transaction.currency == Currency.USD) {
            amountInVND = transaction.amount * exchangeRate;
          }
          totalSpent += amountInVND;
        }
      }
      return totalSpent;
    }
    return 0.0;
  }
}
