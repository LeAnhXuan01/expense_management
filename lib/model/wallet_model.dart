import 'package:cloud_firestore/cloud_firestore.dart';
import 'enum.dart';

class Wallet {
  final String walletId;
  final String userId;
  late  double initialBalance;
  final String name;
  final String icon;
  final String color;
  final Currency currency;
  final bool excludeFromTotal;
  final DateTime createdAt;
  final bool isDefault;

  Wallet({
    required this.walletId,
    required this.userId,
    required this.initialBalance,
    required this.name,
    required this.icon,
    required this.color,
    required this.currency,
    this.excludeFromTotal = false,
    required this.createdAt,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'walletId': walletId,
      'userId': userId,
      'initialBalance': initialBalance,
      'name': name,
      'icon': icon,
      'color': color,
      'currency': currency == Currency.VND ? 'VND' : 'USD',
      'excludeFromTotal': excludeFromTotal,
      'createdAt': createdAt,
      'isDefault': isDefault,
    };
  }

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      walletId: map['walletId'],
      userId: map['userId'],
      initialBalance: map['initialBalance'],
      name: map['name'],
      icon: map['icon'],
      color: map['color'],
      currency: map['currency'] == 'VND' ? Currency.VND : Currency.USD,
      excludeFromTotal: map['excludeFromTotal'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isDefault: map['isDefault'],
    );
  }
}
