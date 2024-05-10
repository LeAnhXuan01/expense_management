import 'package:flutter/cupertino.dart';

enum TransactionType { income, expense }

class Transaction {
  final IconData icon;
  final String name;
  final DateTime date;
  final double amount;
  final TransactionType type;

  Transaction({
    required this.icon,
    required this.name,
    required this.date,
    required this.amount,
    required this.type,
  });
}