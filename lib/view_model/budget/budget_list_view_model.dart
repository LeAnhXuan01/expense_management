import 'package:easy_localization/easy_localization.dart';
import 'package:expense_management/services/category_service.dart';
import 'package:expense_management/services/wallet_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      return tr('all_expense_categories');
    }
    if (selectedCategories.length == 1) {
      return categoryMap[selectedCategories[0]]?.name ?? '';
    }
    if (selectedCategories.length == 2) {
      return '${categoryMap[selectedCategories[0]]?.name ?? ''}, ${categoryMap[selectedCategories[1]]?.name ?? ''}';
    }
    return '${categoryMap[selectedCategories[0]]?.name ?? ''}, ${categoryMap[selectedCategories[1]]?.name ?? ''} + ${selectedCategories.length - 2}' + tr('other_categories');
  }

  String getWalletsText(List<String> selectedWallets) {
    if (selectedWallets.length == 0 ||
        selectedWallets.length == walletMap.length) return tr('all_wallet');
    if (selectedWallets.length == 1)
      return walletMap[selectedWallets[0]]?.name ?? '';
    if (selectedWallets.length == 2)
      return '${walletMap[selectedWallets[0]]?.name ?? ''}, ${walletMap[selectedWallets[1]]?.name ?? ''}';
    return '${walletMap[selectedWallets[0]]?.name ?? ''}, ${walletMap[selectedWallets[1]]?.name ?? ''} + ${selectedWallets.length - 2} ' + tr('wallet');
  }

  Future<double> calculateSpentAmount(
      Budget budget, List<String> categoryIds, List<String> walletIds) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<Transactions> transactions = await _transactionService.getTransaction(user.uid);
      double totalSpent = 0.0;

      final currentDate = DateTime.now();
      final startDate = budget.startDate;
      final endDate = budget.endDate;

      if (currentDate.isBefore(startDate)) {
        return 0.0;
      }

      DateTime cycleStartDate = startDate;
      DateTime cycleEndDate;

      switch (budget.repeat) {
        case Repeat.Daily:
          cycleEndDate = cycleStartDate.add(Duration(days: 1)).subtract(Duration(seconds: 1));
          break;
        case Repeat.Weekly:
          cycleEndDate = cycleStartDate.add(Duration(days: 7)).subtract(Duration(seconds: 1));
          break;
        case Repeat.Monthly:
          cycleEndDate = DateTime(cycleStartDate.year, cycleStartDate.month + 1, cycleStartDate.day)
              .subtract(Duration(seconds: 1));
          break;
        case Repeat.Quarterly:
          cycleEndDate = DateTime(cycleStartDate.year, cycleStartDate.month + 3, cycleStartDate.day)
              .subtract(Duration(seconds: 1));
          break;
        case Repeat.Yearly:
          cycleEndDate = DateTime(cycleStartDate.year + 1, cycleStartDate.month, cycleStartDate.day)
              .subtract(Duration(seconds: 1));
          break;
        default:
          return 0.0;
      }

      while (cycleStartDate.isBefore(currentDate) && cycleStartDate.isBefore(endDate)) {
        double cycleSpent = 0.0;
        for (var transaction in transactions) {
          if (transaction.date.isAfter(cycleStartDate.subtract(Duration(seconds: 1))) &&
              transaction.date.isBefore(cycleEndDate.add(Duration(seconds: 1))) &&
              categoryIds.contains(transaction.categoryId) &&
              walletIds.contains(transaction.walletId)) {
            double amount = transaction.amount;
            cycleSpent += amount;
          }
        }
        totalSpent = cycleSpent; // Cập nhật tổng số tiền đã chi trong chu kỳ hiện tại

        switch (budget.repeat) {
          case Repeat.Daily:
            cycleStartDate = cycleEndDate.add(Duration(seconds: 1));
            cycleEndDate = cycleStartDate.add(Duration(days: 1)).subtract(Duration(seconds: 1));
            break;
          case Repeat.Weekly:
            cycleStartDate = cycleEndDate.add(Duration(seconds: 1));
            cycleEndDate = cycleStartDate.add(Duration(days: 7)).subtract(Duration(seconds: 1));
            break;
          case Repeat.Monthly:
            cycleStartDate = cycleEndDate.add(Duration(seconds: 1));
            cycleEndDate = DateTime(cycleStartDate.year, cycleStartDate.month + 1, cycleStartDate.day)
                .subtract(Duration(seconds: 1));
            break;
          case Repeat.Quarterly:
            cycleStartDate = cycleEndDate.add(Duration(seconds: 1));
            cycleEndDate = DateTime(cycleStartDate.year, cycleStartDate.month + 3, cycleStartDate.day)
                .subtract(Duration(seconds: 1));
            break;
          case Repeat.Yearly:
            cycleStartDate = cycleEndDate.add(Duration(seconds: 1));
            cycleEndDate = DateTime(cycleStartDate.year + 1, cycleStartDate.month, cycleStartDate.day)
                .subtract(Duration(seconds: 1));
            break;
        }
      }

      return totalSpent;
    }
    return 0.0;
  }

  String getDisplayTime(Budget budget) {
    final currentDate = DateTime.now();
    final startDate = budget.startDate;
    final endDate = budget.endDate;

    if (currentDate.isAfter(endDate)) {
      return tr('expired');
    }

    switch (budget.repeat) {
      case Repeat.Daily:
        // Nếu chưa đến thời gian bắt đầu hạn mức, hiển thị ngày bắt đầu hạn mức
        if (currentDate.isBefore(startDate)) {
          return DateFormat('dd/MM/yyyy').format(startDate);
        }
        // Hiển thị ngày hiện tại nếu đã trong hạn mức
        return DateFormat('dd/MM/yyyy').format(currentDate);

      case Repeat.Weekly:
        // Tính tuần bắt đầu hiện tại dựa trên ngày bắt đầu hạn mức
        final weekStartDate = startDate.add(Duration(
            days: ((currentDate.difference(startDate).inDays) ~/ 7) * 7));
        final weekEndDate = weekStartDate.add(Duration(days: 6));
        if (weekEndDate.isAfter(endDate)) {
          return tr('expired');
        }
        // Nếu chưa đến thời gian bắt đầu hạn mức, hiển thị tuần bắt đầu hạn mức
        if (currentDate.isBefore(startDate)) {
          final initialWeekEndDate = startDate.add(Duration(days: 6));
          return '${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(initialWeekEndDate)}';
        }
        return '${DateFormat('dd/MM/yyyy').format(weekStartDate)} - ${DateFormat('dd/MM/yyyy').format(weekEndDate)}';

      case Repeat.Monthly:
        DateTime monthStartDate =
            DateTime(startDate.year, startDate.month, startDate.day);
        while (monthStartDate.isBefore(currentDate) &&
            monthStartDate.isBefore(endDate)) {
          monthStartDate = DateTime(
              monthStartDate.year, monthStartDate.month + 1, startDate.day);
        }
        if (monthStartDate.isAfter(endDate)) {
          return tr('expired');
        }
        // Nếu chưa đến thời gian bắt đầu hạn mức, hiển thị tháng bắt đầu hạn mức
        if (currentDate.isBefore(startDate)) {
          final initialMonthEndDate =
              DateTime(startDate.year, startDate.month + 1, startDate.day)
                  .subtract(Duration(days: 1));
          return '${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(initialMonthEndDate)}';
        }
        monthStartDate = DateTime(monthStartDate.year, monthStartDate.month - 1,
            startDate.day); // Move back one month
        final monthEndDate = DateTime(monthStartDate.year,
                monthStartDate.month + 1, monthStartDate.day)
            .subtract(Duration(days: 1));
        return '${DateFormat('dd/MM/yyyy').format(monthStartDate)} - ${DateFormat('dd/MM/yyyy').format(monthEndDate)}';

      case Repeat.Quarterly:
        DateTime quarterStartDate = startDate;
        while (quarterStartDate.isBefore(currentDate) &&
            quarterStartDate.isBefore(endDate)) {
          quarterStartDate = DateTime(quarterStartDate.year,
              quarterStartDate.month + 3, quarterStartDate.day);
        }
        if (quarterStartDate.isAfter(endDate)) {
          return tr('expired');
        }
        // Nếu chưa đến thời gian bắt đầu hạn mức, hiển thị quý bắt đầu hạn mức
        if (currentDate.isBefore(startDate)) {
          final initialQuarterEndDate =
              DateTime(startDate.year, startDate.month + 3, startDate.day)
                  .subtract(Duration(days: 1));
          return '${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(initialQuarterEndDate)}';
        }
        quarterStartDate = DateTime(
            quarterStartDate.year,
            quarterStartDate.month - 3,
            quarterStartDate.day); // Move back one quarter
        final quarterEndDate = DateTime(quarterStartDate.year,
                quarterStartDate.month + 3, quarterStartDate.day)
            .subtract(Duration(days: 1));
        return '${DateFormat('dd/MM/yyyy').format(quarterStartDate)} - ${DateFormat('dd/MM/yyyy').format(quarterEndDate)}';

      case Repeat.Yearly:
        DateTime yearStartDate =
            DateTime(startDate.year, startDate.month, startDate.day);
        while (yearStartDate.isBefore(currentDate) &&
            yearStartDate.isBefore(endDate)) {
          yearStartDate =
              DateTime(yearStartDate.year + 1, startDate.month, startDate.day);
        }
        if (yearStartDate.isAfter(endDate)) {
          return tr('expired');
        }
        // Nếu chưa đến thời gian bắt đầu hạn mức, hiển thị năm bắt đầu hạn mức
        if (currentDate.isBefore(startDate)) {
          final initialYearEndDate =
              DateTime(startDate.year + 1, startDate.month, startDate.day)
                  .subtract(Duration(days: 1));
          return '${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(initialYearEndDate)}';
        }
        yearStartDate = DateTime(yearStartDate.year - 1, startDate.month,
            startDate.day); // Move back one year
        final yearEndDate =
            DateTime(yearStartDate.year + 1, startDate.month, startDate.day)
                .subtract(Duration(days: 1));
        return '${DateFormat('dd/MM/yyyy').format(yearStartDate)} - ${DateFormat('dd/MM/yyyy').format(yearEndDate)}';

      default:
        return tr('unknown');
    }
  }

  int getDaysLeft(Budget budget) {
    final currentDate = DateTime.now();
    final startDate = budget.startDate;
    final endDate = budget.endDate;

    if (currentDate.isBefore(startDate)) {
      return 0;
    }

    switch (budget.repeat) {
      case Repeat.Daily:
        DateTime dailyStartDate = startDate;
        while (dailyStartDate.isBefore(currentDate) &&
            dailyStartDate.isBefore(endDate)) {
          dailyStartDate = dailyStartDate.add(Duration(days: 1));
        }
        // if (dailyStartDate.isAfter(endDate)) {
        //   return 0;
        // }
        // return endDate.difference(currentDate).inDays;
        return 0;

      case Repeat.Weekly:
        final weekStartDate = startDate.add(Duration(
            days: ((currentDate.difference(startDate).inDays) ~/ 7) * 7));
        final weekEndDate = weekStartDate.add(Duration(days: 6));
        if (currentDate.isAfter(weekEndDate) || currentDate.isAfter(endDate)) {
          return 0;
        }
        if (weekEndDate.isAfter(endDate)) {
          return endDate.difference(currentDate).inDays + 1;
        }
        return weekEndDate.difference(currentDate).inDays + 1;

      case Repeat.Monthly:
        DateTime monthStartDate;
        DateTime monthEndDate;

        if (currentDate.day >= startDate.day) {
          monthStartDate =
              DateTime(currentDate.year, currentDate.month, startDate.day);
          monthEndDate =
              DateTime(currentDate.year, currentDate.month + 1, startDate.day)
                  .subtract(Duration(days: 1));
        } else {
          monthStartDate =
              DateTime(currentDate.year, currentDate.month - 1, startDate.day);
          monthEndDate =
              DateTime(currentDate.year, currentDate.month, startDate.day)
                  .subtract(Duration(days: 1));
        }

        if (currentDate.isAfter(monthEndDate) || currentDate.isAfter(endDate)) {
          return 0;
        }
        if (monthEndDate.isAfter(endDate)) {
          return endDate.difference(currentDate).inDays + 1;
        }
        return monthEndDate.difference(currentDate).inDays + 1;

      case Repeat.Quarterly:
        final quarter = ((currentDate.month - 1) ~/ 3) + 1;
        final quarterStartMonth = (quarter - 1) * 3 + 1;
        final nextQuarterStartMonth = quarterStartMonth + 3;
        DateTime quarterStartDate =
            DateTime(currentDate.year, quarterStartMonth, startDate.day);
        DateTime quarterEndDate =
            DateTime(currentDate.year, nextQuarterStartMonth, startDate.day)
                .subtract(Duration(days: 1));

        if (currentDate.day < startDate.day) {
          quarterStartDate =
              DateTime(currentDate.year, quarterStartMonth - 3, startDate.day);
          quarterEndDate =
              DateTime(currentDate.year, quarterStartMonth, startDate.day)
                  .subtract(Duration(days: 1));
        }

        if (currentDate.isAfter(quarterEndDate) ||
            currentDate.isAfter(endDate)) {
          return 0;
        }
        if (quarterEndDate.isAfter(endDate)) {
          return endDate.difference(currentDate).inDays + 1;
        }
        return quarterEndDate.difference(currentDate).inDays + 1;

      case Repeat.Yearly:
        DateTime yearStartDate =
            DateTime(currentDate.year, startDate.month, startDate.day);
        DateTime yearEndDate =
            DateTime(currentDate.year + 1, startDate.month, startDate.day)
                .subtract(Duration(days: 1));

        if (currentDate.isBefore(yearStartDate)) {
          yearStartDate =
              DateTime(currentDate.year - 1, startDate.month, startDate.day);
          yearEndDate =
              DateTime(currentDate.year, startDate.month, startDate.day)
                  .subtract(Duration(days: 1));
        }

        if (currentDate.isAfter(yearEndDate) || currentDate.isAfter(endDate)) {
          return 0;
        }
        if (yearEndDate.isAfter(endDate)) {
          return endDate.difference(currentDate).inDays + 1;
        }
        return yearEndDate.difference(currentDate).inDays + 1;

      default:
        return 0;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
