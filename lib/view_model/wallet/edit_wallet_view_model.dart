import 'package:easy_localization/easy_localization.dart';
import 'package:expense_management/view_model/wallet/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_management/model/wallet_model.dart';
import 'package:expense_management/services/wallet_service.dart';
import '../../utils/utils.dart';

class EditWalletViewModel extends ChangeNotifier {
  final WalletService _walletService = WalletService();
  final TextEditingController walletNameController = TextEditingController();
  final TextEditingController initialBalanceController = TextEditingController();

  IconData? selectedIcon;
  Color? selectedColor;
  bool enableButton = false;
  bool showPlusButtonIcon = true;
  bool showPlusButtonColor = true;
  bool excludeFromTotal = false;

  bool get isEmptyWalletName => walletNameController.text.isEmpty;
  bool get isEmptyInitialBalance => initialBalanceController.text.isEmpty;
  bool get isEmptyIcon => selectedIcon == null;
  bool get isEmptyColor => selectedColor == null;

  EditWalletViewModel() {
    initialBalanceController.addListener(formatInitialBalance);
  }

  void initialize(Wallet wallet) {
    walletNameController.text = wallet.name;
    initialBalanceController.text = formatAmount(wallet.initialBalance);
    selectedIcon = parseIcon(wallet.icon);
    selectedColor = parseColor(wallet.color);
    excludeFromTotal = wallet.excludeFromTotal;
    updateButtonState();
  }

  void formatInitialBalance() {
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
