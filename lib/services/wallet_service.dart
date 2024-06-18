import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_management/model/wallet_model.dart';
import '../data/default_wallet.dart';

class WalletService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDefaultWallets(String userId) async {
    final userWallets = await _firestore.collection('wallets')
        .where('userId', isEqualTo: userId)
        .get();

    if (userWallets.docs.isEmpty) {
      for (var wallet in defaultWallets) {
        var newWallet = Wallet(
            walletId: _firestore.collection('wallets').doc().id,
            userId: userId,
            initialBalance: wallet.initialBalance,
            name: wallet.name,
            icon: wallet.icon,
            color: wallet.color,
            currency: wallet.currency,
            createdAt: DateTime.now(),
        );

        await _firestore.collection('wallets').doc(newWallet.walletId).set(newWallet.toMap());
      }
    }
  }

  Future<void> addFixedWallet(String userId) async {
    try {
      // Check if there are any fixed categories already existing for the user
      final querySnapshot = await _firestore
          .collection('wallets')
          .where('userId', isEqualTo: userId)
          .where('isDefault', isEqualTo: true)
          .limit(1)  // Limit the query to check for at least one result
          .get();

      // If no fixed categories exist, add them
      if (querySnapshot.docs.isEmpty) {
        for (var wallet in fixedWallets) {
          var newWallet = Wallet(
            walletId: _firestore.collection('wallets').doc().id,
            userId: userId,
            initialBalance: wallet.initialBalance,
            name: wallet.name,
            icon: wallet.icon,
            color: wallet.color,
            currency: wallet.currency,
            createdAt: DateTime.now(),
            isDefault: true,
          );

          await _firestore
              .collection('wallets')
              .doc(newWallet.walletId)
              .set(newWallet.toMap());
        }
      }
    } catch (e) {
      print("Error adding fixed wallets: $e");
      throw e;  // Rethrow the error to handle it further up the call stack if needed
    }
  }

  Future<bool> isFixedWallet(String walletId) async {
    try {
      final walletDoc = await _firestore.collection('wallets').doc(walletId).get();
      if (walletDoc.exists) {
        final walletData = walletDoc.data();
        return walletData?['isDefault'] ?? false;
      }
    } catch (e) {
      print('Error checking fixed wallet: $e');
    }
    return false;
  }

  Future<List<Wallet>> getWallets(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('wallets')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs.map((doc) => Wallet.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Error getting wallets: $e");
      throw e;
    }
  }

  Future<void> createWallet(Wallet wallet) async {
    try {
      DocumentReference docRef = await _firestore.collection('wallets').add(wallet.toMap());
      await docRef.update({'walletId': docRef.id});
    } catch (e) {
      print("Error creating wallet: $e");
      throw e;
    }
  }

  Future<void> updateWallet(Wallet wallet) async {
    try {
      await _firestore
          .collection('wallets')
          .doc(wallet.walletId)
          .update(wallet.toMap());
    } catch (e) {
      print("Error updating wallet: $e");
      throw e;
    }
  }

  Future<void> deleteWallet(String walletId) async {
    try {
      await _firestore
          .collection('wallets')
          .doc(walletId)
          .delete();
    } catch (e) {
      print("Error deleting wallet: $e");
      throw e;
    }
  }
}
