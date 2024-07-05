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

String formatAmount(double amount, Currency currency) {
  final formatter = NumberFormat('#,###', 'vi_VN');

  if (amount >= 1000000000) {
    return '${formatter.format((amount / 1))}';
  } else if (amount >= 1000000) {
    return '${formatter.format((amount / 1))}';
  } else if (amount >= 1000) {
    return '${formatter.format(amount.round())}';
  } else {
    return amount.toStringAsFixed(0);
  }
}

String formatAmount_2(double amount, Currency currency) {
  final formatter = NumberFormat('#,###.##', 'vi_VN');

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

void formatAmount_3(TextEditingController amountController) {
  final text = amountController.text;
  if (text.isEmpty) return;

  // Remove non-digit characters
  final cleanedText = text.replaceAll(RegExp(r'[^0-9]'), '');

  // Parse to int and format
  final number = int.parse(cleanedText);
  final formatted = NumberFormat('#,###', 'vi_VN').format(number);

  // Update the text controller
  amountController.value = TextEditingValue(
    text: formatted,
    selection: TextSelection.collapsed(offset: formatted.length),
  );
}

String formatTotalBalance(double totalBalance) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  if (totalBalance >= 1000000000) {
    return '${formatter.format((totalBalance / 1))}';
  } else if (totalBalance >= 1000000) {
    return '${formatter.format((totalBalance / 1))}';
  } else if (totalBalance >= 1000) {
    return '${formatter.format(totalBalance.round())}';
  } else {
    return totalBalance.toStringAsFixed(0);
  }
}

String formatAmountChart(double totalBalance) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  if (totalBalance >= 1000000000) {
    return '${formatter.format((totalBalance / 1000000000))} T';
  } else if (totalBalance >= 1000000) {
    return '${formatter.format((totalBalance / 1000000))} Tr';
  } else if (totalBalance >= 1000) {
    return '${formatter.format(totalBalance.round())}';
  } else {
    return totalBalance.toStringAsFixed(0);
  }
}

String chartTotalAmountFormat(double totalAmount, Currency currency) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  if (currency == Currency.USD) {
    totalAmount *= 25442.5;
  }

  if (totalAmount >= 1000000000) {
    return '${formatter.format((totalAmount / 1))} ₫';
  } else if (totalAmount >= 1000000) {
    return '${formatter.format((totalAmount / 1))} ₫';
  } else if (totalAmount >= 1000) {
    return '${formatter.format(totalAmount.round())} ₫';
  } else {
    return '${totalAmount.toStringAsFixed(0)} ₫';
  }
}

DateTime parseDateKey(String dateKey, String selectedTimeframe) {
  switch (selectedTimeframe) {
    case 'day':
    // Format: 'dd-MM-yyyy'
      final parts = dateKey.split('-');
      if (parts.length == 3) {
        return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      } else {
        throw FormatException('Invalid date format in dateKey: $dateKey');
      }
    case 'custom':
    // Format: 'Từ dd-MM-yyyy đến dd-MM-yyyy'
      final customPattern = RegExp(r'Từ (\d{1,2}-\d{1,2}-\d{4}) đến (\d{1,2}-\d{1,2}-\d{4})');
      final customMatch = customPattern.firstMatch(dateKey);
      if (customMatch != null) {
        final startDateParts = customMatch.group(1)!.split('-');
        return DateTime(int.parse(startDateParts[2]), int.parse(startDateParts[1]), int.parse(startDateParts[0]));
      } else {
        throw FormatException('Invalid custom format in dateKey: $dateKey');
      }
    case 'week':
    // Format: 'Từ dd-MM-yyyy đến dd-MM-yyyy'
      final weekPattern = RegExp(r'Từ (\d{1,2}-\d{1,2}-\d{4}) đến (\d{1,2}-\d{1,2}-\d{4})');
      final match = weekPattern.firstMatch(dateKey);
      if (match != null) {
        final startDateParts = match.group(1)!.split('-');
        return DateTime(int.parse(startDateParts[2]), int.parse(startDateParts[1]), int.parse(startDateParts[0]));
      } else {
        throw FormatException('Invalid week format in dateKey: $dateKey');
      }
    case 'month':
    // Format: 'Tháng MM-yyyy'
      final parts = dateKey.split(' ');
      if (parts.length == 2) {
        final monthYearParts = parts[1].split('-');
        return DateTime(int.parse(monthYearParts[1]), int.parse(monthYearParts[0]));
      } else {
        throw FormatException('Invalid month format in dateKey: $dateKey');
      }
    case 'year':
    // Format: 'năm yyyy'
      final yearPattern = RegExp(r'Năm (\d{4})');
      final match = yearPattern.firstMatch(dateKey);
      if (match != null) {
        final year = int.parse(match.group(1)!);
        return DateTime(year);
      } else {
        throw FormatException('Invalid year format in dateKey: $dateKey');
      }
    default:
      throw FormatException('Unknown timeframe: $selectedTimeframe');
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

class CurrencyUtils {
  static final double exchangeRate = 25442.5; // 1 USD = 25442.5 VND

  static double convertCurrency(double amount, Currency fromCurrency, Currency toCurrency) {
    if (fromCurrency == toCurrency) {
      return amount;
    }

    switch (fromCurrency) {
      case Currency.VND:
        return toCurrency == Currency.USD ? amount / exchangeRate : amount;
      case Currency.USD:
        return toCurrency == Currency.VND ? amount * exchangeRate : amount;
      default:
        return amount;
    }
  }
}

double convertToVND(double amount, Currency currency) {
  const double exchangeRate = 25442.5;
  if (currency == Currency.USD) {
    return amount * exchangeRate;
  }
  return amount;
}
