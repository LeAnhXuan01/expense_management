import 'enum.dart';

class Transaction {
  String transactionId;
  String userId;
  double amount;
  TransactionType type;
  String walletId;
  String categoryId;
  String date;
  String time;
  String note;
  String image;

  Transaction({
    required this.transactionId,
    required this.userId,
    required this.amount,
    required this.type,
    required this.walletId,
    required this.categoryId,
    required this.date,
    required this.time,
    required this.note,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'userId': userId,
      'amount': amount,
      'type': type.index,
      'walletId': walletId,
      'categoryId': categoryId,
      'date': date,
      'time': time,
      'note': note,
      'image': image,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      transactionId: map['transactionId'],
      userId: map['userId'],
      amount: map['amount'],
      type: TransactionType.values[map['type']],
      walletId: map['walletId'],
      categoryId: map['categoryId'],
      date: map['date'],
      time: map['time'],
      note: map['note'],
      image: map['image'],
    );
  }
}