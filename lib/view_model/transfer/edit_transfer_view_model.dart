import 'package:expense_management/widget/custom_snackbar_1.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_management/model/transfer_model.dart';
import 'package:expense_management/model/wallet_model.dart';
import 'package:expense_management/services/transfer_service.dart';
import 'package:expense_management/services/wallet_service.dart';
import 'package:intl/intl.dart';
import '../../model/enum.dart';
import '../../utils/utils.dart';
import 'package:collection/collection.dart';

import '../wallet/wallet_view_model.dart';
class EditTransferViewModel extends ChangeNotifier {
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

  EditTransferViewModel() {
    amountController.addListener(_formatAmount);
  }

  void initialize(Transfer transfer){
    loadWallets(transfer);
    amountController.text = transfer.amount.toStringAsFixed(0);
    _formatAmount();
    selectedDate = transfer.date;
    selectedHour = TimeOfDay(hour: transfer.hour.hour, minute: transfer.hour.minute);
    _updateDateController();
    _updateHourController();
    noteController.text = transfer.note;
    updateButtonState();
  }


  Future<void> loadWallets(Transfer transfer) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        wallets = await _walletService.getWallets(user.uid);
        selectedFromWallet = wallets.firstWhereOrNull((wallet) => wallet.walletId == transfer.fromWallet);
        selectedToWallet = wallets.firstWhereOrNull((wallet) => wallet.walletId == transfer.toWallet);
        notifyListeners();
      } catch (e) {
        print("Error loading wallets: $e");
      }
    }
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
    updateButtonState();
    notifyListeners();
  }

  void setSelectedHour(TimeOfDay value) {
    selectedHour = value;
    _updateHourController();
    updateButtonState();
    notifyListeners();
  }

  void _updateDateController() {
    dateController.text = formatDate(selectedDate);
  }

  void _updateHourController() {
    hourController.text = formatHour(selectedHour);
  }

  void updateButtonState() {
    enableButton = selectedFromWallet != null &&
        selectedToWallet != null &&
        amountController.text.isNotEmpty;
    notifyListeners();
  }

  void _formatAmount() {
    final text = amountController.text;
    if (text.isEmpty) return;

    final cleanedText = text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanedText.isNotEmpty) {
      final number = int.parse(cleanedText);
      final formatted = NumberFormat('#,###', 'vi_VN').format(number);

      amountController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  Future<Transfer?> updateTransfer(BuildContext context, String transferId, WalletViewModel walletViewModel) async {
    if (selectedFromWallet == selectedToWallet) {
      CustomSnackBar_1.show(context, 'Không thể chuyển khoản cùng ví');
      return null;
    }
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      // Lấy danh sách các giao dịch của người dùng
      List<Transfer> transfers = await _transferService.getTransfers(user.uid);

      // Tìm giao dịch cũ theo transferId
      final oldTransfer = transfers.firstWhereOrNull((transfer) => transfer.transferId == transferId);

      if (oldTransfer == null) {
        CustomSnackBar_1.show(context, 'Không tìm thấy giao dịch chuyển khoản');
        return null;
      }

      final cleanedAmount = amountController.text.replaceAll('.', '');
      final amount = double.parse(cleanedAmount);
      final updateTransfer = Transfer(
          transferId: transferId,
          userId: user.uid,
          fromWallet: selectedFromWallet!.walletId,
          toWallet: selectedToWallet!.walletId,
          amount: amount,
          currency: Currency.VND,
          date: selectedDate,
          hour: TimeOfDay(hour: selectedHour.hour, minute: selectedHour.minute),
          note: noteController.text,
      );

      // Lấy ví cũ
      Wallet? oldFromWallet = wallets.firstWhereOrNull((wallet) => wallet.walletId == oldTransfer.fromWallet);
      Wallet? oldToWallet = wallets.firstWhereOrNull((wallet) => wallet.walletId == oldTransfer.toWallet);

      try {
        // Hoàn lại số tiền cho ví nguồn cũ
        if (oldFromWallet != null) {
          if (oldFromWallet.currency == Currency.USD) {
            oldFromWallet.initialBalance += oldTransfer.amount / 25442.5;
          } else {
            oldFromWallet.initialBalance += oldTransfer.amount;
          }
          await _walletService.updateWallet(oldFromWallet);
        }

        // Trừ số tiền từ ví đích cũ
        if (oldToWallet != null) {
          if (oldToWallet.currency == Currency.USD) {
            oldToWallet.initialBalance -= oldTransfer.amount / 25442.5;
          } else {
            oldToWallet.initialBalance -= oldTransfer.amount;
          }
          await _walletService.updateWallet(oldToWallet);
        }

        // Trừ số tiền từ ví nguồn mới
        if (selectedFromWallet!.currency == Currency.USD) {
          selectedFromWallet!.initialBalance -= amount / 25442.5;
        } else {
          selectedFromWallet!.initialBalance -= amount;
        }
        await _walletService.updateWallet(selectedFromWallet!);

        // Cộng số tiền vào ví đích mới
        if (selectedToWallet!.currency == Currency.USD) {
          selectedToWallet!.initialBalance += amount / 25442.5;
        } else {
          selectedToWallet!.initialBalance += amount;
        }
        await _walletService.updateWallet(selectedToWallet!);

        // Cập nhật giao dịch
        await _transferService.updateTransfer(updateTransfer);

        // Load lại danh sách ví và thông báo thay đổi
        await walletViewModel.loadWallets();
        return updateTransfer;
      } catch (e) {
        print('Error updating transfer: $e');
        // Show snackbar or alert that update failed
        return null;
      }
    }
    return null;
  }
}
