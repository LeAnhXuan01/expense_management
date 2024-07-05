import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_management/model/wallet_model.dart';
import 'package:expense_management/services/wallet_service.dart';
import 'package:intl/intl.dart';
import '../../model/enum.dart';
import '../../utils/utils.dart';

class CreateWalletViewModel extends ChangeNotifier {
  final WalletService _walletService = WalletService();
  final TextEditingController walletNameController = TextEditingController();
  final TextEditingController initialBalanceController = TextEditingController();
  IconData? selectedIcon;
  Color? selectedColor;
  Currency selectedCurrency = Currency.VND;

  bool enableButton = false;
  bool showPlusButtonIcon = true;
  bool showPlusButtonColor = true;
  bool excludeFromTotal = false;

  bool get isEmptyWalletName => walletNameController.text.isEmpty;
  bool get isEmptyInitialBalance => initialBalanceController.text.isEmpty;
  bool get isEmptyIcon => selectedIcon == null;
  bool get isEmptyColor => selectedColor == null;

  CreateWalletViewModel() {
    initialBalanceController.addListener((){
      formatAmount_3(initialBalanceController);
    });
  }

  void updateButtonState() {
    enableButton = !isEmptyWalletName &&
        !isEmptyInitialBalance &&
        !isEmptyIcon &&
        !isEmptyColor;
    notifyListeners();
  }

  void setSelectedCurrency(Currency currency) {
    if (selectedCurrency != currency) {
      final cleanedBalance = initialBalanceController.text.replaceAll(',', '').replaceAll('₫', '').replaceAll('\$', '');
      final currentBalance = double.tryParse(cleanedBalance) ?? 0;

      final newBalance = CurrencyUtils.convertCurrency(currentBalance, selectedCurrency, currency);

      selectedCurrency = currency;
      initialBalanceController.text = NumberFormat('#,###', 'vi_VN').format(newBalance);

      notifyListeners();
    }
  }


  void setSelectedIcon(IconData icon) {
    selectedIcon = icon;
    updateButtonState();
  }

  void setSelectedColor(Color color) {
    selectedColor = color;
    updateButtonState();
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

  Future<Wallet?> createWallet() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cleanedBalance = initialBalanceController.text.replaceAll('.', '');
      final initialBalance = double.parse(cleanedBalance);

      Wallet newWallet = Wallet(
        walletId: '',
        userId: user.uid,
        initialBalance: initialBalance,
        name: walletNameController.text,
        icon: selectedIcon.toString(),
        color: selectedColor.toString(),
        currency: selectedCurrency,
        excludeFromTotal: excludeFromTotal,
        createdAt: DateTime.now(),
      );

      try {
        await _walletService.createWallet(newWallet);
        return newWallet;
      } catch (e) {
        print('Error creating wallet: $e');
        return null;
      }
    }
    return null;
  }

  void resetFields() {
    walletNameController.clear();
    initialBalanceController.clear();
    selectedIcon = null;
    selectedColor = null;
    showPlusButtonIcon = true;
    showPlusButtonColor = true;
    selectedCurrency = Currency.VND;
    enableButton = false;
    excludeFromTotal = false;
    notifyListeners();
  }
}
