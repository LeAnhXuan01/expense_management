import 'package:expense_management/view_model/wallet/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_management/model/wallet_model.dart';
import 'package:expense_management/services/wallet_service.dart';
import 'package:intl/intl.dart';
import '../../model/enum.dart';
import '../../utils/utils.dart';

class EditWalletViewModel extends ChangeNotifier {
  final TextEditingController walletNameController = TextEditingController();
  final TextEditingController initialBalanceController = TextEditingController();
  IconData? selectedIcon;
  Color? selectedColor;
  Currency selectedCurrency = Currency.VND;

  bool enableButton = false;
  bool showPlusButtonIcon = true;
  bool showPlusButtonColor = true;
  bool excludeFromTotal = false;

  final WalletService _walletService = WalletService();

  bool get isEmptyWalletName => walletNameController.text.isEmpty;
  bool get isEmptyInitialBalance => initialBalanceController.text.isEmpty;
  bool get isEmptyIcon => selectedIcon == null;
  bool get isEmptyColor => selectedColor == null;

  EditWalletViewModel() {
    initialBalanceController.addListener(_formatInitialBalance);
  }

  void initialize(Wallet wallet) {
    walletNameController.text = wallet.name;
    initialBalanceController.text = NumberFormat('#,###', 'vi_VN').format(wallet.initialBalance);
    selectedIcon = parseIcon(wallet.icon);
    selectedColor = parseColor(wallet.color);
    selectedCurrency = wallet.currency;
    excludeFromTotal = wallet.excludeFromTotal;
    updateButtonState();
  }

  void _formatInitialBalance() {
    final text = initialBalanceController.text;
    if (text.isEmpty) return;

    final cleanedText = text.replaceAll(RegExp(r'[^0-9]'), '');

    final number = int.parse(cleanedText);
    final formatted = NumberFormat('#,###', 'vi_VN').format(number);

    initialBalanceController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void updateButtonState() {
    enableButton = !isEmptyWalletName && !isEmptyInitialBalance && !isEmptyIcon && !isEmptyColor;
    notifyListeners();
  }

  void setSelectedIcon(IconData icon) {
    selectedIcon = icon;
    updateButtonState();
  }

  void setSelectedColor(Color color) {
    selectedColor = color;
    updateButtonState();
  }

  void setSelectedCurrency(Currency currency) {
    // Chuyển đổi số tiền dựa trên loại tiền tệ
    final exchangeRate = 25442.5; // 1 USD = 25442.5 VND

    // Lấy số dư hiện tại
    final cleanedBalance = initialBalanceController.text.replaceAll('.', '');
    final currentBalance = double.parse(cleanedBalance);

    // Chuyển đổi số dư
    double newBalance = currentBalance;
    if (selectedCurrency == Currency.VND && currency == Currency.USD) {
      newBalance = currentBalance / exchangeRate; // VND to USD
    } else if (selectedCurrency == Currency.USD && currency == Currency.VND) {
      newBalance = currentBalance * exchangeRate; // USD to VND
    }

    // Cập nhật loại tiền tệ và số dư mới
    selectedCurrency = currency;
    initialBalanceController.text = NumberFormat('#,###', 'vi_VN').format(newBalance);

    notifyListeners();
  }

  void toggleShowPlusButtonIcon() {
    showPlusButtonIcon = !showPlusButtonIcon;
    notifyListeners();
  }

  void toggleShowPlusButtonColor() {
    showPlusButtonColor = !showPlusButtonColor;
    notifyListeners();
  }

  void setExcludeFromTotal(bool value) {
    excludeFromTotal = value;
    notifyListeners();
  }

  Future<Wallet?> updateWallet(String walletId, DateTime createdAt) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cleanedBalance = initialBalanceController.text.replaceAll('.', '');
      final initialBalance = double.parse(cleanedBalance);

      // Kiểm tra trạng thái isDefault của ví hiện tại
      bool isDefault = await _walletService.isFixedWallet(walletId);

      Wallet updatedWallet = Wallet(
        walletId: walletId,
        userId: user.uid,
        initialBalance: initialBalance,
        name: walletNameController.text,
        icon: selectedIcon.toString(),
        color: selectedColor.toString(),
        currency: selectedCurrency,
        excludeFromTotal: excludeFromTotal,
        createdAt: createdAt,
        isDefault: isDefault,
      );

      try {
        await _walletService.updateWallet(updatedWallet);
        return updatedWallet;
      } catch (e) {
        print('Error updating wallet: $e');
        return null;
      }
    }
    return null;
  }
}
