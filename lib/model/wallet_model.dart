import 'enum.dart';

class Wallet {
  String walletId;
  String userId;
  double initialBalance;
  String name;
  String icon;
  String color;
  Currency currency;

  Wallet({
    required this.walletId,
    required this.userId,
    required this.initialBalance,
    required this.name,
    required this.icon,
    required this.color,
    required this.currency,
  });

  Map<String, dynamic> toMap() {
    return {
      'walletId': walletId,
      'userId': userId,
      'initialBalance': initialBalance,
      'name': name,
      'icon': icon,
      'color': color,
      'currency': currency.index,
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
      currency: Currency.values[map['currency']],
    );
  }
}