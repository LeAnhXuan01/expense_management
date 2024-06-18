import 'package:flutter/material.dart';

import 'enum.dart';

class Transfer {
  final String transferId;
  final String userId;
  final String fromWallet;
  final String toWallet;
  final double amount;
  final Currency currency;
  final DateTime date;
  final TimeOfDay hour;
  final String note;

  Transfer({
    required this.transferId,
    required this.userId,
    required this.fromWallet,
    required this.toWallet,
    required this.amount,
    required this.currency,
    required this.date,
    required this.hour,
    this.note = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'transferId': transferId,
      'userId': userId,
      'fromWalletId': fromWallet,
      'toWalletId': toWallet,
      'amount': amount,
      'currency': currency == Currency.VND ? 'VND' : 'USD',
      'date': date.toIso8601String(),
      'hour': '${hour.hour}:${hour.minute.toString().padLeft(2, '0')}',
      'note': note,
    };
  }

  factory Transfer.fromMap(Map<String, dynamic> map) {
    return Transfer(
      transferId: map['transferId'],
      userId: map['userId'],
      fromWallet: map['fromWalletId'],
      toWallet: map['toWalletId'],
      amount: map['amount'],
      currency: map['currency'] == 'VND' ? Currency.VND : Currency.USD,
      date: DateTime.parse(map['date']), // Chuyển đổi từ chuỗi ISO 8601 sang DateTime
      hour: TimeOfDay(
          hour: int.parse(map['hour'].split(':')[0]),
          minute: int.parse(map['hour'].split(':')[1])),
      note: map['note'],
    );
  }
}