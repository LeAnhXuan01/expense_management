import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/enum.dart';

Color parseColor(String colorString) {
  final colorValue = int.parse(colorString.split('(0x')[1].split(')')[0], radix: 16);
  return Color(colorValue);
}

IconData parseIcon(String iconString) {
  try {
    // Trích xuất giá trị mã Unicode từ chuỗi và chuyển đổi thành IconData
    final iconValue = int.parse(
      iconString.split('U+').last.split(')').first,
      radix: 16,
    );
    return IconData(iconValue, fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter',);
  } catch (e) {
    print('Error parsing icon data: $e');
    return Icons.error; // Trả về một biểu tượng lỗi nếu có lỗi xảy ra
  }
}

String formatInitialBalance(double balance, Currency currency) {
  final formatter = NumberFormat('#,###', 'vi_VN');

  if (currency == Currency.USD) {
    if (balance >= 1000000000) {
      return '${formatter.format((balance / 1))}';
    } else if (balance >= 1000000) {
      return '${formatter.format((balance / 1))}';
    } else if (balance >= 1000) {
      return '${formatter.format(balance.round())}';
    } else {
      return balance.toStringAsFixed(0);
    }
  }

  if (balance >= 1000000000) {
    return '${formatter.format((balance / 1))}';
  } else if (balance >= 1000000) {
    return '${formatter.format((balance / 1))}';
  } else if (balance >= 1000) {
    return '${formatter.format(balance.round())}';
  } else {
    return balance.toStringAsFixed(0);
  }
}

String formatAmountTransfer(double amount, Currency currency) {
  final formatter = NumberFormat('#,###', 'vi_VN');

  if (amount >= 1000000000) {
    return '${formatter.format((amount / 1000000000))} T';
  } else if (amount >= 1000000) {
    return '${formatter.format((amount / 1000000))} Tr';
  } else if (amount >= 1000) {
    return '${formatter.format(amount.round())}';
  } else {
    return amount.toStringAsFixed(0);
  }
}

String formatDate(DateTime date) {
  final daysOfWeek = [
    'Chủ Nhật',
    'Thứ Hai',
    'Thứ Ba',
    'Thứ Tư',
    'Thứ Năm',
    'Thứ Sáu',
    'Thứ Bảy'
  ];
  final dayOfWeek =
  daysOfWeek[date.weekday % 7]; // % 7 để điều chỉnh Chủ Nhật về index 0
  return "$dayOfWeek - ${date.day}/${date.month}/${date.year}";
}

String formatHour(TimeOfDay time) {
  return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
}

String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Chào buổi sáng';
  } else if (hour < 19) {
    return 'Chào buổi chiều';
  } else {
    return 'Chào buổi tối';
  }
}