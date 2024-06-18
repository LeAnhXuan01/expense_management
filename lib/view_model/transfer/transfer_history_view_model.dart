import 'package:expense_management/model/transfer_model.dart';
import 'package:expense_management/model/wallet_model.dart';
import 'package:expense_management/services/transfer_service.dart';
import 'package:expense_management/services/wallet_service.dart';
import 'package:expense_management/view_model/wallet/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../model/enum.dart';
import '../../utils/utils.dart';

class TransferHistoryViewModel extends ChangeNotifier {
  final TransferService _transferService = TransferService();
  final WalletService _walletService = WalletService();

  List<Transfer> _transfers = [];
  Map<String, List<Transfer>> _groupedTransfers = {};
  Map<String, Wallet> _walletMap = {};
  Transfer? _recentlyDeletedTransfer;
  DateTimeRange? _selectedDateRange;
  String? _selectedWalletId;

  List<Transfer> get transfers => _transfers;
  Map<String, List<Transfer>> get groupedTransfers => _groupedTransfers;
  Map<String, Wallet> get walletMap => _walletMap;
  DateTimeRange? get selectedDateRange => _selectedDateRange;
  String? get selectedWalletId => _selectedWalletId;

  TransferHistoryViewModel() {
    loadTransfers();
  }

  Future<void> loadTransfers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        _transfers = await _transferService.getTransfers(user.uid);
        await _loadWallets();
        _applyFilters();
        notifyListeners();
      } catch (e) {
        print("Error loading transfers: $e");
      }
    }
  }

  Future<void> _loadWallets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        List<Wallet> wallets = await _walletService.getWallets(user.uid);
        _walletMap = {for (var wallet in wallets) wallet.walletId: wallet};
      } catch (e) {
        print("Error loading wallets: $e");
      }
    }
  }

  void _applyFilters() {
    final filteredTransfers = _filteredTransfers();
    _groupTransfersByDate(filteredTransfers);
  }

  void _groupTransfersByDate(List<Transfer> transfers) {
    _groupedTransfers = {};
    for (var transfer in transfers) {
      final DateTime transferDate = transfer.date;
      final String formattedDate = DateFormat('dd/MM/yyyy').format(transferDate);

      if (_groupedTransfers.containsKey(formattedDate)) {
        _groupedTransfers[formattedDate]!.add(transfer);
      } else {
        _groupedTransfers[formattedDate] = [transfer];
      }
    }

    _groupedTransfers.forEach((key, value) {
      value.sort((a, b) {
        final DateTime aDateTime = DateTime(0, 1, 1, a.hour.hour, a.hour.minute);
        final DateTime bDateTime = DateTime(0, 1, 1, b.hour.hour, b.hour.minute);
        return bDateTime.compareTo(aDateTime);
      });
    });
  }

  List<Transfer> _filteredTransfers() {
    return _transfers.where((transfer) {
      if (_selectedDateRange != null) {
        if (transfer.date.isBefore(_selectedDateRange!.start) ||
            transfer.date.isAfter(_selectedDateRange!.end)) {
          return false;
        }
      }
      if (_selectedWalletId != null) {
        if (transfer.fromWallet != _selectedWalletId &&
            transfer.toWallet != _selectedWalletId) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  void filterByDateRange(DateTimeRange dateRange) {
    _selectedDateRange = dateRange;
    _applyFilters();
    notifyListeners();
  }

  void filterByWallet(String? walletId) {
    _selectedWalletId = walletId;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _selectedDateRange = null;
    _selectedWalletId = null;
    _applyFilters();
    notifyListeners();
  }

  String formatHour(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  String getWalletName(String walletId) {
    return _walletMap[walletId]?.name ?? walletId;
  }

  IconData? getWalletIcon(String walletId) {
    return parseIcon(_walletMap[walletId]?.icon ?? walletId);
  }

  Color? getWalletColor(String walletId) {
    return parseColor(_walletMap[walletId]?.color ?? walletId);
  }

  void _sortTransfersByDate() {
    _transfers.sort((a, b) => b.date.compareTo(a.date));
  }


  Future<void> deleteTransfer(String transferId, WalletViewModel walletViewModel) async {
    try {
      // Tìm giao dịch chuyển khoản sẽ bị xóa
      final transfer = _transfers.firstWhere((transfer) => transfer.transferId == transferId);

      // Lưu lại thông tin giao dịch đã xóa để truy cập số tiền và các ví liên quan
      _recentlyDeletedTransfer = transfer;

      // Xóa giao dịch chuyển khoản
      await _transferService.deleteTransfer(transferId);

      // Xóa giao dịch chuyển khoản khỏi danh sách
      _transfers.removeWhere((transfer) => transfer.transferId == transferId);

      // Tìm các ví liên quan đến giao dịch đã xóa
      final fromWallet = _walletMap[transfer.fromWallet];
      final toWallet = _walletMap[transfer.toWallet];

      // Cập nhật số dư của ví nguồn và ví đích
      if (fromWallet != null && toWallet != null) {
        if (fromWallet.currency == Currency.USD) {
          // Nếu ví nguồn là USD, cần chuyển đổi số tiền về VND
          fromWallet.initialBalance += transfer.amount / 25442.5; // Chuyển đổi từ USD sang VND với tỷ giá 1 USD = 25442.5 VND
        } else {
          fromWallet.initialBalance += transfer.amount; // Hoàn lại số tiền vào ví nguồn
        }

        if (toWallet.currency == Currency.USD) {
          // Nếu ví đích là USD, cần chuyển đổi số tiền từ VND sang USD
          toWallet.initialBalance -= transfer.amount / 25442.5; // Chuyển đổi từ VND sang USD với tỷ giá 1 USD = 25442.5 VND
        } else {
          toWallet.initialBalance -= transfer.amount; // Trừ số tiền khỏi ví đích
        }

        // Cập nhật thông tin ví
        await _walletService.updateWallet(fromWallet);
        await _walletService.updateWallet(toWallet);
      }
      await walletViewModel.loadWallets();
      _applyFilters();
      notifyListeners();
    } catch (e) {
      print("Error deleting transfer: $e");
    }
  }

  Future<void> restoreTransfer() async {
    if (_recentlyDeletedTransfer != null) {
      try {
        await _transferService.createTransfer(_recentlyDeletedTransfer!);
        _transfers.add(_recentlyDeletedTransfer!);
        _recentlyDeletedTransfer = null;
        _sortTransfersByDate();
        _applyFilters();
        notifyListeners();
      } catch (e) {
        print("Error restoring transfer: $e");
      }
    }
  }
}

