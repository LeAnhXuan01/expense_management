import 'enum.dart';

class Bill {
  String billId;
  String userId;
  String name;
  RepeatBill repeat;
  String date;
  String time;
  String note;
  bool isActive;

  Bill({
    required this.billId,
    required this.userId,
    required this.name,
    required this.repeat,
    required this.date,
    required this.time,
    required this.note,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'billId': billId,
      'userId': userId,
      'name': name,
      'repeat': repeat.index,
      'date': date,
      'time': time,
      'note': note,
      'isActive': isActive ? 1 : 0,
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      billId: map['billId'],
      userId: map['userId'],
      name: map['name'],
      repeat: RepeatBill.values[map['repeat']],
      date: map['date'],
      time: map['time'],
      note: map['note'],
      isActive: map['isActive'] == 1,
    );
  }
}