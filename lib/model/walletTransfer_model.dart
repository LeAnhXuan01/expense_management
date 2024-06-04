class WalletTransfer {
  String transferId;
  String userId;
  String fromWalletId;
  String toWalletId;
  double amount;
  String timestamp;

  WalletTransfer({
    required this.transferId,
    required this.userId,
    required this.fromWalletId,
    required this.toWalletId,
    required this.amount,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'transferId': transferId,
      'userId': userId,
      'fromWalletId': fromWalletId,
      'toWalletId': toWalletId,
      'amount': amount,
      'timestamp': timestamp,
    };
  }

  factory WalletTransfer.fromMap(Map<String, dynamic> map) {
    return WalletTransfer(
      transferId: map['transferId'],
      userId: map['userId'],
      fromWalletId: map['fromWalletId'],
      toWalletId: map['toWalletId'],
      amount: map['amount'],
      timestamp: map['timestamp'],
    );
  }
}