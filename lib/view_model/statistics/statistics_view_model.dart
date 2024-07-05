import 'package:expense_management/model/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/category_model.dart';
import '../../model/enum.dart';
import '../../model/wallet_model.dart';
import '../../utils/utils.dart';

class ChartData {
  final String date;
  final double amount;

  ChartData(this.date, this.amount);
}

class StatisticsViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<ChartData> incomeData = [];
  List<ChartData> expenseData = [];
  List<ChartData> profitData = [];
  List<ChartData> lossData = [];
  List<Category> categories = [];
  List<Category> selectedCategories = [];
  List<Wallet> wallets = [];
  List<Wallet> selectedWallets = [];
  String selectedTimeframe = 'year';
  DateTime? customStartDate;
  DateTime? customEndDate;
  bool isCustomDateRangeSet = false;
  List<Transactions> incomeTransactions = [];
  List<Transactions> expenseTransactions = [];
  List<Transactions> selectedIncomeTransactions = [];
  List<Transactions> selectedExpenseTransactions = [];
  String currentIncomeDateKey = '';
  String currentExpenseDateKey = '';
  TabController? tabController;

  double get currentIncomeTotal {
    return selectedIncomeTransactions.fold(0, (sum, item) {
      double amountInVND = item.currency == Currency.USD ? item.amount * 25442.5 : item.amount;
      return sum + amountInVND;
    });
  }

  double get currentExpenseTotal {
    return selectedExpenseTransactions.fold(0, (sum, item) {
      double amountInVND = item.currency == Currency.USD ? item.amount * 25442.5 : item.amount;
      return sum + amountInVND;
    });
  }


  List<Transactions> selectedProfitTransactions = [];
  List<Transactions> selectedLossTransactions = [];

  // Thêm một map để lưu trữ categoryId và category tương ứng
  Map<String, Category> categoryMap = {};

  StatisticsViewModel() {
    fetchWallets();
    fetchCategories();
    fetchData();
  }

  void setTabController(TabController controller) {
    tabController = controller;
    tabController!.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (tabController!.indexIsChanging) {
      // Khi tab đang thay đổi, xóa các giao dịch đã chọn
      selectedIncomeTransactions.clear();
      selectedExpenseTransactions.clear();
      notifyListeners();
    }
  }

  void setTimeframe(String timeframe) {
    selectedTimeframe = timeframe;
    if (timeframe != 'custom') {
      isCustomDateRangeSet = false;
    }
    fetchData();
    notifyListeners();
  }

  void setWallets(List<Wallet> wallets) {
    selectedWallets = wallets;
    fetchData();
    notifyListeners();
  }

  void setCategories(List<Category> categories) {
    selectedCategories = categories;
    fetchData();
    notifyListeners();
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    customStartDate = start;
    customEndDate = end;
    isCustomDateRangeSet = true;
    fetchData();
    notifyListeners();
  }

  void setSelectedTransactions(TransactionType type, String date) {
    print('setSelectedTransactions called với type: $type và date: $date');
    DateTime parsedDate;
    DateTime? endDate;
    try {
      parsedDate = parseDateKey(date, selectedTimeframe);
      if (selectedTimeframe == 'custom') {
        final parts = date.split(' ');
        final endDateParts = parts[3].split('-');
        endDate = DateTime(int.parse(endDateParts[2]), int.parse(endDateParts[1]), int.parse(endDateParts[0]));
      }
    } catch (e) {
      print('Lỗi parsing date: $e');
      return;
    }

    if (type == TransactionType.income) {
      currentIncomeDateKey = date;
      selectedIncomeTransactions = incomeTransactions.where((t) {
        return isTransactionInDateRange(t, parsedDate, endDate);
      }).toList();
      selectedExpenseTransactions.clear();
    } else if (type == TransactionType.expense) {
      currentExpenseDateKey = date;
      selectedExpenseTransactions = expenseTransactions.where((t) {
        return isTransactionInDateRange(t, parsedDate, endDate);
      }).toList();
      selectedIncomeTransactions.clear();
    }
    notifyListeners();
  }

  bool isTransactionInDateRange(Transactions t, DateTime startDate, DateTime? endDate) {
    switch (selectedTimeframe) {
      case 'day':
        return t.date.year == startDate.year && t.date.month == startDate.month && t.date.day == startDate.day;
      case 'custom':
        return t.date.isAfter(startDate.subtract(Duration(days: 1))) && t.date.isBefore(endDate!.add(Duration(days: 1)));
      case 'week':
        DateTime monday = t.date.subtract(Duration(days: t.date.weekday - 1));
        return monday.year == startDate.year && monday.month == startDate.month && monday.day == startDate.day;
      case 'month':
        return t.date.year == startDate.year && t.date.month == startDate.month;
      case 'year':
        return t.date.year == startDate.year;
      default:
        return t.date.year == startDate.year && t.date.month == startDate.month && t.date.day == startDate.day;
    }
  }


  Future<void> fetchWallets() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      QuerySnapshot walletSnapshot = await _firestore
          .collection('wallets')
          .where('userId', isEqualTo: currentUser.uid)
          .get();
      wallets = walletSnapshot.docs
          .map((doc) => Wallet.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      selectedWallets = List.from(wallets); // Mặc định chọn tất cả các ví
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      QuerySnapshot categorySnapshot = await _firestore
          .collection('categories')
          .where('userId', isEqualTo: currentUser.uid)
          .get();
      categories = categorySnapshot.docs
          .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      selectedCategories = List.from(categories);

      // Tạo map categoryId -> Category
      categoryMap = {for (var category in categories) category.categoryId: category};

      notifyListeners();
    }
  }

  Future<void> fetchData() async {
    DateTime now = DateTime.now();
    DateTime start;
    DateTime end;
    if (selectedTimeframe == 'custom' &&
        isCustomDateRangeSet &&
        customStartDate != null &&
        customEndDate != null) {
      start = customStartDate!;
      end = customEndDate!;
    } else {
      switch (selectedTimeframe) {
        case 'day':
          start = DateTime(now.year, now.month, now.day);
          end = start.add(Duration(days: 1));
          break;
        case 'week':
          start = now.subtract(Duration(days: now.weekday - 1));
          end = start.add(Duration(days: 7));
          break;
        case 'month':
          start = DateTime(now.year, now.month);
          end = DateTime(now.year, now.month + 1);
          break;
        case 'year':
          start = DateTime(now.year);
          end = DateTime(now.year + 1);
          break;
        default:
          start = DateTime(now.year, now.month, now.day);
          end = start.add(Duration(days: 1));
      }
    }

    Query transactionsQuery = _firestore
        .collection('transactions')
        .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('date', isLessThan: end.toIso8601String());

    if (selectedWallets.isNotEmpty) {
      List<String> selectedWalletIds =
          selectedWallets.map((wallet) => wallet.walletId).toList();
      transactionsQuery =
          transactionsQuery.where('walletId', whereIn: selectedWalletIds);
    }

    QuerySnapshot transactionsSnapshot = await transactionsQuery.get();

    List<Transactions> transactions = transactionsSnapshot.docs
        .map((doc) => Transactions.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    // Process transactions with wallet filter
    // Now apply category filter
    List<Transactions> filteredTransactions = [];

    if (selectedCategories.isNotEmpty) {
      List<String> selectedCategoryIds =
          selectedCategories.map((category) => category.categoryId).toList();

      for (var transaction in transactions) {
        if (selectedCategoryIds.contains(transaction.categoryId)) {
          filteredTransactions.add(transaction);
        }
      }
    } else {
      filteredTransactions = transactions;
    }

    processTransactionData(filteredTransactions);
    //list transaction
    incomeTransactions = filteredTransactions.where((transaction) => transaction.type == TransactionType.income).toList();
    expenseTransactions = filteredTransactions.where((transaction) => transaction.type == TransactionType.expense).toList();
    notifyListeners();
  }

  void processTransactionData(List<Transactions> transactions) {
    print('processTransactionData called with ${transactions.length} transactions');
    Map<String, double> incomeMap = {};
    Map<String, double> expenseMap = {};

    if (selectedTimeframe == 'custom' && isCustomDateRangeSet) {
      // Custom date range format
      final startDate = customStartDate!;
      final endDate = customEndDate!;
      String dateKey = 'Từ ${startDate.day}-${startDate.month}-${startDate.year} đến ${endDate.day}-${endDate.month}-${endDate.year}';

      for (var transaction in transactions) {
        if (transaction.type == TransactionType.income) {
          incomeMap.update(dateKey, (value) => value + transaction.amount, ifAbsent: () => transaction.amount);
        } else if (transaction.type == TransactionType.expense) {
          expenseMap.update(dateKey, (value) => value + transaction.amount, ifAbsent: () => transaction.amount);
        }
      }
    } else {
      for (var transaction in transactions) {
        double amountInVND = transaction.currency == Currency.USD ? transaction.amount * 25442.5 : transaction.amount;

        String dateKey;
        switch (selectedTimeframe) {
          case 'day':
            dateKey = '${transaction.date.day}-${transaction.date.month}-${transaction.date.year}';
            break;
          case 'week':
            DateTime monday = transaction.date.subtract(Duration(days: transaction.date.weekday - 1));
            dateKey = 'Từ ${monday.day}-${monday.month}-${monday.year} đến ${monday.day + 6}-${monday.month}-${monday.year}';
            break;
          case 'month':
            dateKey = 'Tháng ${transaction.date.month}-${transaction.date.year}';
            break;
          case 'year':
            dateKey = 'Năm ${transaction.date.year}';
            break;
          default:
            dateKey = '${transaction.date.day}-${transaction.date.month}-${transaction.date.year}';
        }

        if (transaction.type == TransactionType.income) {
          incomeMap.update(dateKey, (value) => value + amountInVND, ifAbsent: () => amountInVND);
        } else if (transaction.type == TransactionType.expense) {
          expenseMap.update(dateKey, (value) => value + amountInVND, ifAbsent: () => amountInVND);
        }
      }
    }

    incomeData = incomeMap.entries.map((e) => ChartData(e.key, e.value)).toList();
    expenseData = expenseMap.entries.map((e) => ChartData(e.key, e.value)).toList();
    print('Income Data: ${incomeData.length} entries');
    print('Expense Data: ${expenseData.length} entries');

    profitData = [];
    lossData = [];

    incomeData.forEach((income) {
      final expense = expenseMap[income.date] ?? 0.0;
      final profitOrLoss = income.amount - expense;
      if (profitOrLoss >= 0) {
        profitData.add(ChartData(income.date, profitOrLoss));
      } else {
        lossData.add(ChartData(income.date, -profitOrLoss));
      }
    });

    print('Profit Data: ${profitData.length} entries');
    print('Loss Data: ${lossData.length} entries');

    notifyListeners();
  }

}
