import 'package:expense_management/widget/custom_snackbar_1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_management/model/transfer_model.dart';
import 'package:intl/intl.dart';
import '../../model/enum.dart';
import '../../model/wallet_model.dart';
import '../../services/transfer_service.dart';
import '../../services/wallet_service.dart';
import '../../utils/utils.dart';

class TransferViewModel extends ChangeNotifier {
  final TransferService _transferService = TransferService();
  final WalletService _walletService = WalletService();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController hourController = TextEditingController();

  Wallet? selectedFromWallet;
  Wallet? selectedToWallet;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedHour = TimeOfDay.now();
  List<Wallet> wallets = [];
  bool enableButton = false;

  TransferViewModel() {
    loadWallets();
    amountController.addListener(_formatInitialBalance);
    amountController.addListener(updateButtonState);
    _updateDateController();
    _updateHourController();
  }

  void _formatInitialBalance() {
    final text = amountController.text;
    if (text.isEmpty) return;

    // Remove non-digit characters
    final cleanedText = text.replaceAll(RegExp(r'[^0-9]'), '');

    // Parse to int and format
    final number = int.parse(cleanedText);
    final formatted = NumberFormat('#,###', 'vi_VN').format(number);

    // Update the text controller
    amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void setSelectedFromWallet(Wallet? wallet) {
    selectedFromWallet = wallet;
    updateButtonState();
  }

  void setSelectedToWallet(Wallet? wallet) {
    selectedToWallet = wallet;
    updateButtonState();
  }

  void setSelectedDate(DateTime value) {
    selectedDate = value;
    _updateDateController();
    notifyListeners();
  }

  void setSelectedHour(TimeOfDay value) {
    selectedHour = value;
    _updateHourController();
    notifyListeners();
  }

  void _updateDateController() {
    dateController.text = formatDate(selectedDate);
  }

  void _updateHourController() {
    hourController.text = formatHour(selectedHour);
  }


  Future<void> loadWallets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        wallets = await _walletService.getWallets(user.uid);
        notifyListeners();
      } catch (e) {
        print("Error loading wallets: $e");
      }
    }
  }

  void updateButtonState() {
    enableButton = selectedFromWallet != null &&
        selectedToWallet != null &&
        amountController.text.isNotEmpty;
    notifyListeners();
  }

  Future<Transfer?> createTransfer(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (selectedFromWallet == selectedToWallet) {
        CustomSnackBar_1.show(context, 'Không thể chuyển khoản cùng ví');
        return null;
      }

      final cleanedAmount = amountController.text.replaceAll('.', '');
      final amount = double.parse(cleanedAmount);
      final exchangeRate = 25442.5; // 1 USD = 25442.5 VND

      // Đổi tiền từ VND sang USD nếu ví nguồn là USD
      var amountInSourceCurrency = amount;
      if (selectedFromWallet!.currency == Currency.USD) {
        amountInSourceCurrency = amount / exchangeRate; // Đổi từ VND sang USD
      }

      if (selectedFromWallet!.initialBalance < amountInSourceCurrency) {
        CustomSnackBar_1.show(
            context, 'Số dư trong ví không đủ để thực hiện giao dịch');
        return null;
      }

      Transfer newTransfer = Transfer(
        transferId: '',
        userId: user.uid,
        fromWallet: selectedFromWallet!.walletId,
        toWallet: selectedToWallet!.walletId,
        amount: amount,
        currency: Currency.VND,
        date: selectedDate,
        hour: TimeOfDay(hour: selectedHour.hour, minute: selectedHour.minute),
        note: noteController.text,
      );
      try {
        await _transferService.createTransfer(newTransfer);

        // Cập nhật số dư của ví nguồn và ví đích
        if (selectedFromWallet!.currency == Currency.USD) {
          // Nếu ví nguồn là USD, giảm số dư dựa trên USD
          selectedFromWallet!.initialBalance -=
              amount / 25442.5; // Đổi từ VND sang USD
        } else {
          // Nếu ví nguồn là VND, giảm số dư dựa trên VND
          selectedFromWallet!.initialBalance -= amount;
        }
        await _walletService.updateWallet(selectedFromWallet!);

        // Tăng số dư của ví đích
        if (selectedToWallet!.currency == Currency.USD) {
          // Nếu ví đích là USD, tăng số dư dựa trên USD
          selectedToWallet!.initialBalance +=
              amount / 25442.5; // Đổi từ VND sang USD
        } else {
          // Nếu ví đích là VND, tăng số dư dựa trên VND
          selectedToWallet!.initialBalance += amount;
        }
        await _walletService.updateWallet(selectedToWallet!);

        return newTransfer;
      } catch (e) {
        print('Error creating transfer.: $e');
        return null;
      }
    }
    return null;
  }

  void resetFields() {
    selectedFromWallet = null;
    selectedToWallet = null;
    amountController.clear();
    noteController.clear();
    selectedDate = DateTime.now();
    selectedHour = TimeOfDay.now();
    enableButton = false;
    notifyListeners();
  }
}
