import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/transaction_model.dart';
import '../model/enum.dart';
import '../model/transfer_model.dart';
import '../model/wallet_model.dart';
import '../services/wallet_service.dart';

// check and update of transaction
class TransactionHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkBalance(String walletId, double transactionAmount, Currency transactionCurrency, TransactionType transactionType, {Transactions? oldTransaction}) async {
    try {
      DocumentSnapshot walletSnapshot = await _firestore.collection('wallets').doc(walletId).get();

      if (!walletSnapshot.exists) {
        throw Exception("Wallet not found");
      }

      Map<String, dynamic> walletData = walletSnapshot.data() as Map<String, dynamic>;
      double walletBalance = walletData['initialBalance'];
      String walletCurrency = walletData['currency'];

      // Tính toán số tiền giao dịch hiện tại trong đơn vị tiền của ví
      double amountInWalletCurrency = transactionAmount;
      if (walletCurrency == 'VND' && transactionCurrency == Currency.USD) {
        amountInWalletCurrency = transactionAmount * 25442.5;
      } else if (walletCurrency == 'USD' && transactionCurrency == Currency.VND) {
        amountInWalletCurrency = transactionAmount / 25442.5;
      }

      // Nếu có giao dịch cũ (đang cập nhật), thực hiện điều chỉnh số dư ví
      if (oldTransaction != null) {
        // Điều chỉnh lại số dư của ví trước khi cập nhật
        double oldAmountInWalletCurrency = oldTransaction.amount;
        if (walletCurrency == 'VND' && oldTransaction.currency == Currency.USD) {
          oldAmountInWalletCurrency = oldTransaction.amount * 25442.5;
        } else if (walletCurrency == 'USD' && oldTransaction.currency == Currency.VND) {
          oldAmountInWalletCurrency = oldTransaction.amount / 25442.5;
        }

        if (oldTransaction.type == TransactionType.income) {
          walletBalance -= oldAmountInWalletCurrency;
        } else if (oldTransaction.type == TransactionType.expense) {
          walletBalance += oldAmountInWalletCurrency;
        }
      }

      // Kiểm tra số dư ví sau khi điều chỉnh giao dịch cũ
      if (transactionType == TransactionType.expense) {
        return walletBalance >= amountInWalletCurrency;
      }

      return true; // Đối với thu nhập, không cần kiểm tra số dư
    } catch (e) {
      print("Error checking balance: $e");
      throw e;
    }
  }


  Future<void> updateWalletBalance(Transactions transaction, {required bool isCreation, required bool isDeletion, Transactions? oldTransaction}) async {
    try {
      DocumentSnapshot walletSnapshot = await _firestore.collection('wallets').doc(transaction.walletId).get();

      if (!walletSnapshot.exists) {
        throw Exception("Wallet not found");
      }

      Map<String, dynamic> walletData = walletSnapshot.data() as Map<String, dynamic>;
      double currentBalance = walletData['initialBalance'];
      String walletCurrency = walletData['currency'];

      double amountInWalletCurrency = transaction.amount;
      double oldAmountInWalletCurrency = oldTransaction != null ? oldTransaction.amount : 0;

      if (walletCurrency == 'VND' && transaction.currency == Currency.USD) {
        amountInWalletCurrency = transaction.amount * 25442.5;
        if (oldTransaction != null) {
          oldAmountInWalletCurrency = oldTransaction.amount * 25442.5;
        }
      } else if (walletCurrency == 'USD' && transaction.currency == Currency.VND) {
        amountInWalletCurrency = transaction.amount / 25442.5;
        if (oldTransaction != null) {
          oldAmountInWalletCurrency = oldTransaction.amount / 25442.5;
        }
      }

      if (isCreation) {
        if (transaction.type == TransactionType.income) {
          currentBalance += amountInWalletCurrency;
        } else if (transaction.type == TransactionType.expense) {
          currentBalance -= amountInWalletCurrency;
        }
      } else if (isDeletion) {
        if (transaction.type == TransactionType.income) {
          currentBalance -= amountInWalletCurrency;
        } else if (transaction.type == TransactionType.expense) {
          currentBalance += amountInWalletCurrency;
        }
      } else {
        if (oldTransaction != null) {
          // Hoàn tác số dư của giao dịch cũ
          if (oldTransaction.type == TransactionType.income) {
            currentBalance -= oldAmountInWalletCurrency;
          } else if (oldTransaction.type == TransactionType.expense) {
            currentBalance += oldAmountInWalletCurrency;
          }
        }
        // Áp dụng số dư của giao dịch mới
        if (transaction.type == TransactionType.income) {
          currentBalance += amountInWalletCurrency;
        } else if (transaction.type == TransactionType.expense) {
          currentBalance -= amountInWalletCurrency;
        }
      }

      await _firestore.collection('wallets').doc(transaction.walletId).update({'initialBalance': currentBalance});
    } catch (e) {
      print("Error updating wallet initialBalance: $e");
      throw e;
    }
  }

  Future<void> updateWalletsForTransactionUpdate(Transactions newTransaction, Transactions oldTransaction) async {
    try {
      if (newTransaction.walletId != oldTransaction.walletId) {
        // Hoàn tác ảnh hưởng của giao dịch cũ lên ví cũ
        await updateWalletBalance(oldTransaction, isCreation: false, isDeletion: true);
        // Áp dụng ảnh hưởng của giao dịch mới lên ví mới
        await updateWalletBalance(newTransaction, isCreation: true, isDeletion: false);
      } else {
        // Nếu ví không đổi, chỉ cần cập nhật số dư trong cùng một ví
        await updateWalletBalance(newTransaction, isCreation: false, isDeletion: false, oldTransaction: oldTransaction);
      }
    } catch (e) {
      print("Error updating wallets for transaction update: $e");
      throw e;
    }
  }
}

class TransferHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkBalance(String walletId, double amount, Currency currency) async {
    try {
      DocumentSnapshot walletSnapshot = await _firestore.collection('wallets').doc(walletId).get();

      if (!walletSnapshot.exists) {
        throw Exception("Wallet not found");
      }

      Map<String, dynamic> walletData = walletSnapshot.data() as Map<String, dynamic>;
      double walletBalance = walletData['initialBalance'];
      String walletCurrency = walletData['currency'];

      // Tính toán số tiền chuyển khoản hiện tại trong đơn vị tiền của ví
      double amountInWalletCurrency = amount;
      if (walletCurrency == 'VND' && currency == Currency.USD) {
        amountInWalletCurrency = amount * 25442.5;
      } else if (walletCurrency == 'USD' && currency == Currency.VND) {
        amountInWalletCurrency = amount / 25442.5;
      }

      return walletBalance >= amountInWalletCurrency;
    } catch (e) {
      print("Error checking balance: $e");
      throw e;
    }
  }

  Future<void> updateWalletBalance(String walletId, double amount, Currency currency, bool isIncome) async {
    try {
      DocumentSnapshot walletSnapshot = await _firestore.collection('wallets').doc(walletId).get();

      if (!walletSnapshot.exists) {
        throw Exception("Wallet not found");
      }

      Map<String, dynamic> walletData = walletSnapshot.data() as Map<String, dynamic>;
      double currentBalance = walletData['initialBalance'];
      String walletCurrency = walletData['currency'];

      double amountInWalletCurrency = amount;
      if (walletCurrency == 'VND' && currency == Currency.USD) {
        amountInWalletCurrency = amount * 25442.5;
      } else if (walletCurrency == 'USD' && currency == Currency.VND) {
        amountInWalletCurrency = amount / 25442.5;
      }

      if (isIncome) {
        currentBalance += amountInWalletCurrency;
      } else {
        currentBalance -= amountInWalletCurrency;
      }

      await _firestore.collection('wallets').doc(walletId).update({'initialBalance': currentBalance});
    } catch (e) {
      print("Error updating wallet initialBalance: $e");
      throw e;
    }
  }

  Future<void> updateWalletsForTransfer(Transfer newTransfer, {Transfer? oldTransfer}) async {
    try {
      if (oldTransfer != null) {
        // Hoàn tác ảnh hưởng của giao dịch cũ lên ví cũ
        await updateWalletBalance(oldTransfer.fromWallet, oldTransfer.amount, oldTransfer.currency, true);
        await updateWalletBalance(oldTransfer.toWallet, oldTransfer.amount, oldTransfer.currency, false);
      }

      // Áp dụng ảnh hưởng của giao dịch mới lên ví mới
      await updateWalletBalance(newTransfer.fromWallet, newTransfer.amount, newTransfer.currency, false);
      await updateWalletBalance(newTransfer.toWallet, newTransfer.amount, newTransfer.currency, true);
    } catch (e) {
      print("Error updating wallets for transfer: $e");
      throw e;
    }
  }
}





