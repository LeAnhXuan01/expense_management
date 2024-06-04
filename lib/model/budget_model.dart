import 'enum.dart';

class Budget {
  String budgetId;
  String userId;
  double amount;
  String name;
  String categoryId;
  String walletId;
  RepeatBudget repeat;
  String startDate;
  String endDate;

  Budget({
    required this.budgetId,
    required this.userId,
    required this.amount,
    required this.name,
    required this.categoryId,
    required this.walletId,
    required this.repeat,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'budgetId': budgetId,
      'userId': userId,
      'amount': amount,
      'name': name,
      'categoryId': categoryId,
      'walletId': walletId,
      'repeat': repeat.index,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      budgetId: map['budgetId'],
      userId: map['userId'],
      amount: map['amount'],
      name: map['name'],
      categoryId: map['categoryId'],
      walletId: map['walletId'],
      repeat: RepeatBudget.values[map['repeat']],
      startDate: map['startDate'],
      endDate: map['endDate'],
    );
  }
}