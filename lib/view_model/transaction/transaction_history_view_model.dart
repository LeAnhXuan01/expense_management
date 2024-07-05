import 'package:expense_management/model/enum.dart';
import 'package:expense_management/services/category_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../model/transaction_model.dart';
import 'package:intl/intl.dart';
import '../../model/category_model.dart';
import '../../model/wallet_model.dart';
import '../../services/transaction_service.dart';
import '../../services/wallet_service.dart';
import '../../utils/wallet_utils.dart';
import '../wallet/wallet_view_model.dart';

class TransactionHistoryViewModel extends ChangeNotifier {
  final TransactionService _transactionService = TransactionService();
  final CategoryService _categoryService = CategoryService();
  final WalletService _walletService = WalletService();
  final TransactionHelper _transactionHelper = TransactionHelper();

  List<Transactions> transactions = [];
  Map<String, Wallet> walletMap = {};
  Map<String, Category> categoryMap = {};
  List<Transactions> filteredTransactions = [];
  Map<String, List<Transactions>> groupedTransactions = {};
  DateTimeRange? selectedDateRange;
  String? selectedWalletId;
  String? selectedTypeFilter;
  String currentSortCriteria = 'date';
  bool isSearching = false;
  String searchQuery = "";

  TransactionHistoryViewModel() {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try{
        transactions = await _transactionService.getTransaction(user.uid);
        await loadWallets();
        await loadCategories();
        filteredTransactions = transactions;
        groupTransactions();
        notifyListeners();
      } catch (e){
        print("Error loading transaction: $e");
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
        categoryMap = {for (var category in categories) category.categoryId: category};
      } catch (e) {
        print("Error loading categories: $e");
      }
    }
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
  void filterByDateRange(DateTimeRange range) {
    selectedDateRange = range;
    _applyFilters();
  }

  void filterByWallet(String walletId) {
    selectedWalletId = walletId;
    _applyFilters();
  }

  void filterByType(String type) {
    selectedTypeFilter = type;
    _applyFilters();
  }

  // void _sortFilteredTransactions() {
  //   if (currentSortCriteria == 'date') {
  //     sortTransactionsByDate();
  //   } else if (currentSortCriteria == 'amount') {
  //     sortTransactionsByAmount();
  //   }
  // }
  //
  // // Sorting by da
  // void sortTransactionsByDate() {
  //   transactions.sort((a, b) => b.date.compareTo(a.date));
  //   currentSortCriteria = 'date';
  //   _groupTransactions();
  //   // _applyFilters();
  // }
  //
  // void sortTransactionsByAmount() {
  //   try {
  //     filteredTransactions.sort((a, b) => b.amount.compareTo(a.amount));
  //     currentSortCriteria = 'amount';
  //     _groupTransactions(); // Cập nhật lại nhóm giao dịch sau khi sắp xếp
  //     // _applyFilters();
  //   } catch (e) {
  //     print('Error sorting transactions: $e');
  //   }
  // }
  //
  // void setCurrentSortCriteria(String criteria) {
  //   currentSortCriteria = criteria;
  //   _sortFilteredTransactions();
  //   notifyListeners();
  // }


  void _applyFilters() {
    filteredTransactions = transactions;
    if (selectedDateRange != null) {
      filteredTransactions = filteredTransactions.where((transaction) {
        return transaction.date.isAfter(selectedDateRange!.start) &&
            transaction.date.isBefore(selectedDateRange!.end);
      }).toList();
    }
    if (selectedWalletId != null) {
      filteredTransactions = filteredTransactions
          .where((transaction) => transaction.walletId == selectedWalletId)
          .toList();
    }
    if (selectedTypeFilter != null && selectedTypeFilter != 'Tất cả') {
      filteredTransactions = filteredTransactions.where((transaction) {
        if (selectedTypeFilter == 'Thu nhập') {
          return transaction.type == TransactionType.income;
        } else if (selectedTypeFilter == 'Chi tiêu') {
          return transaction.type == TransactionType.expense;
        }
        return true;
      }).toList();
    }

    // _sortFilteredTransactions();
    groupTransactions();
    notifyListeners();
  }


  Wallet? getWalletByTransaction(Transactions transaction) {
    return walletMap[transaction.walletId];
  }

  Category? getCategoryByTransaction(Transactions transaction) {
    return categoryMap[transaction.categoryId];
  }

  void searchTransactions(String query) {
    searchQuery = query.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filteredTransactions = filteredTransactions.where((transaction) {
        final category = getCategoryByTransaction(transaction);
        final categoryName = category?.name.toLowerCase() ?? '';
        final note = transaction.note.toLowerCase();
        return categoryName.contains(searchQuery) || note.contains(searchQuery);
      }).toList();
    } else {
      // filteredTransactions = _transactions;
      _applyFilters();
    }
    groupTransactions();
    notifyListeners();
  }

  void clearSearch() {
    searchQuery = "";
    _applyFilters();
    groupTransactions();
    notifyListeners();
  }

  void clearFilters() {
    selectedDateRange = null;
    selectedWalletId = null;
    selectedTypeFilter = null;
    filteredTransactions = transactions;
    // currentSortCriteria = 'date'; // Đặt lại tiêu chí sắp xếp về 'date'
    // sortTransactionsByDate();
    groupTransactions();
    notifyListeners();
  }

  Future<void> deleteTransaction(String transactionId, WalletViewModel walletViewModel) async {
    try {
      // Lấy thông tin của giao dịch trước khi xóa
      final transaction = await _transactionService.getTransactionById(transactionId);
      if (transaction == null) {
        print("Transaction not found");
        return;
      }

      // Cập nhật lại số dư ví
      await _transactionHelper.updateWalletBalance(transaction, isCreation: false, isDeletion: true);

      // Xóa giao dịch
      await _transactionService.deleteTransaction(transactionId);
      transactions.removeWhere((transaction) => transaction.transactionId == transactionId);

      // Tải lại thông tin ví và cập nhật giao diện
      await walletViewModel.loadWallets();
      _applyFilters();
      notifyListeners();
    } catch (e) {
      print("Error deleting transaction: $e");
    }
  }
}
