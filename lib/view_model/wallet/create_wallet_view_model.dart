import 'package:expense_management/view_model/wallet/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_management/model/wallet_model.dart';
import 'package:expense_management/services/wallet_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/enum.dart';

class CreateWalletViewModel extends ChangeNotifier {
  final TextEditingController walletNameController = TextEditingController();
  final TextEditingController initialBalanceController =
      TextEditingController();
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

  CreateWalletViewModel() {
    initialBalanceController.addListener(_formatInitialBalance);
  }

  void _formatInitialBalance() {
    final text = initialBalanceController.text;
    if (text.isEmpty) return;

    // Remove non-digit characters
    final cleanedText = text.replaceAll(RegExp(r'[^0-9]'), '');

    // Parse to int and format
    final number = int.parse(cleanedText);
    final formatted = NumberFormat('#,###', 'vi_VN').format(number);

    // Update the text controller
    initialBalanceController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void updateButtonState() {
    enableButton = !isEmptyWalletName &&
        !isEmptyInitialBalance &&
        !isEmptyIcon &&
        !isEmptyColor;
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
    selectedCurrency = currency;
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

  Future<Wallet?> createWallet() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cleanedBalance = initialBalanceController.text.replaceAll('.', '');
      final initialBalance = double.parse(cleanedBalance);
      Wallet newWallet = Wallet(
        walletId: '',
        // Firestore will assign this
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
