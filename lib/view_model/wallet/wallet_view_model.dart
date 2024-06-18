import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/model/wallet_model.dart';
import 'package:expense_management/services/wallet_service.dart';
import 'package:intl/intl.dart';

import '../../model/enum.dart';

class WalletViewModel extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();

  final WalletService _walletService = WalletService();
  List<Wallet> _wallets = [];
  List<Wallet> _filteredWallets = [];
  double _totalBalance = 0;
  bool isSearching = false;
  late String searchQuery = "";
  Wallet? _selectedWallet;

  List<Wallet> get wallets => _filteredWallets;
  String get formattedTotalBalance => _formatTotalBalance();
  Wallet? get selectedWallet => _selectedWallet;
  double get totalBalance => _totalBalance;

  WalletViewModel() {
    loadWallets();
  }

  void selectWallet(Wallet wallet) {
    _selectedWallet = wallet;
    notifyListeners();
  }

  Future<void> loadWallets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _walletService.addDefaultWallets(user.uid);
        await _walletService.addFixedWallet(user.uid);
        _wallets = await _walletService.getWallets(user.uid);
        _filteredWallets = _wallets; // Ban đầu hiển thị tất cả các ví
        _calculateTotalBalance();
        notifyListeners();
      } catch (e) {
        print("Error loading wallets: $e");
      }
    }
  }

  void filterWallets(String query) {
    if (query.isEmpty) {
      _filteredWallets = _wallets;
    } else {
      _filteredWallets = _wallets.where((wallet) {
        return wallet.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> addWallet(Wallet wallet) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _walletService.createWallet(wallet);
        await loadWallets();  // Tải lại danh sách ví và cập nhật tổng số dư
      } catch (e) {
        print("Error adding wallet: $e");
      }
    }
  }

  Future<void> updateWallet(Wallet wallet) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _walletService.updateWallet(wallet);
        await loadWallets();  // Tải lại danh sách ví và cập nhật tổng số dư
      } catch (e) {
        print("Error updating wallet: $e");
      }
    }
  }

  Future<void> deleteWallet(String walletId) async {
    try {
      await _walletService.deleteWallet(walletId);
      await loadWallets();
    } catch (e) {
      print("Error deleting wallet: $e");
    }
  }

  void _calculateTotalBalance() {
    double total = 0;

    for (var wallet in _wallets) {
      double balance = wallet.initialBalance;
      if (wallet.currency == Currency.USD) {
        // Convert USD to VND (using a fixed exchange rate)
        balance *= 25442.5;
      }
      if (!wallet.excludeFromTotal) {
        total += balance;
      }
    }
    _totalBalance = total;
    notifyListeners();
  }

  String _formatTotalBalance() {
    final formatter = NumberFormat('#,###', 'vi_VN'); // Sử dụng dấu chấm làm dấu phân cách
    if (_totalBalance >= 1000000000) {
      return '${formatter.format((_totalBalance / 1))}';
    } else if (_totalBalance >= 1000000) {
      return '${formatter.format((_totalBalance / 1))}';
    } else if (_totalBalance >= 1000) {
      return '${formatter.format(_totalBalance.round())}';
    } else {
      return _totalBalance.toStringAsFixed(0);
    }
  }
}
