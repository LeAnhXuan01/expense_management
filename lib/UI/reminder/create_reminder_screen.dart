// import 'package:expense_management/widget/custom_ElevatedButton_2.dart';
// import 'package:expense_management/widget/custom_header.dart';
// import 'package:flutter/material.dart';
// import '../../model/reminder_model.dart';
// import '../../services/reminder_service.dart';
//
// class CreateReminderScreen extends StatefulWidget {
//
//   @override
//   _CreateReminderScreenState createState() => _CreateReminderScreenState();
// }
//
// class _CreateReminderScreenState extends State<CreateReminderScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _noteController = TextEditingController();
//   String _frequency = 'Một lần';
//   DateTime _startDate = DateTime.now();
//   late TimeOfDay _time;
//   bool _isActive = true;
//   final ReminderService _reminderService = ReminderService();
//
//   @override
//   void initState() {
//     super.initState();
//     final now = DateTime.now();
//     final initialTime = TimeOfDay(hour: now.hour + 1, minute: now.minute);
//     _time = (initialTime.hour >= 24)
//         ? TimeOfDay(hour: initialTime.hour - 24, minute: initialTime.minute)
//         : initialTime;
//     _startDate = (initialTime.hour >= 24) ? now.add(Duration(days: 1)) : now;
//   }
//
//   String formatDate(DateTime date) {
//     List<String> months = [
//       "tháng 1", "tháng 2", "tháng 3", "tháng 4", "tháng 5", "tháng 6",
//       "tháng 7", "tháng 8", "tháng 9", "tháng 10", "tháng 11", "tháng 12"
//     ];
//     return '${date.day} ${months[date.month - 1]}, ${date.year}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedDate = formatDate(_startDate);
//
//     return Scaffold(
//       body: Column(
//         children: [
//           CustomHeader(title: 'Tạo lời nhắc'),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: ListView(
//                   children: [
//                     TextFormField(
//                       controller: _titleController,
//                       maxLength: 50,
//                       decoration: InputDecoration(labelText: 'Tên lời nhắc'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Vui lòng nhập tên lời nhắc';
//                         }
//                         return null;
//                       },
//                     ),
//                     DropdownButtonFormField<String>(
//                       value: _frequency,
//                       items: [
//                         'Một lần',
//                         'Mỗi ngày',
//                         'Mỗi tuần',
//                         'Mỗi 2 tuần',
//                         'Mỗi tháng',
//                         'Mỗi 2 tháng',
//                         'Mỗi quý',
//                         'Mỗi 6 tháng',
//                         'Mỗi năm'
//                       ].map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         setState(() {
//                           _frequency = newValue!;
//                         });
//                       },
//                       decoration: InputDecoration(labelText: 'Tần suất nhắc nhở'),
//                     ),
//                     SizedBox(height: 16),
//                     Text('Ngày bắt đầu nhắc nhở'),
//                     ListTile(
//                       title: Text(formattedDate),
//                       trailing: Icon(Icons.calendar_today),
//                       onTap: _selectDate,
//                     ),
//                     Text('Chọn giờ'),
//                     ListTile(
//                       title: Text(
//                         '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
//                       ),
//                       trailing: Icon(Icons.access_time),
//                       onTap: _selectTime,
//                     ),
//                     TextFormField(
//                       controller: _noteController,
//                       maxLength: 4000,
//                       decoration: InputDecoration(labelText: 'Ghi chú'),
//                     ),
//                     SizedBox(height: 20),
//                     CustomElevatedButton_2(
//                       onPressed: () async {
//                         if (_formKey.currentState!.validate()) {
//                           final now = DateTime.now();
//                           final selectedDateTime = DateTime(
//                             _startDate.year,
//                             _startDate.month,
//                             _startDate.day,
//                             _time.hour,
//                             _time.minute,
//                           );
//
//                           if (selectedDateTime.isBefore(now)) {
//                             await showDialog(
//                               context: context,
//                               builder: (context) => AlertDialog(
//                                 title: Text('Nhắc nhở đã quá hạn'),
//                                 content: Text('Hãy thay đổi thời gian nhắc nhở'),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () => Navigator.of(context).pop(),
//                                     child: Text('OK'),
//                                   ),
//                                 ],
//                               ),
//                             );
//                             return;
//                           }
//
//                           final reminder = Reminder(
//                             name: _titleController.text,
//                             frequency: _frequency,
//                             startDate: _startDate.toIso8601String(),
//                             reminderTime: _time.format(context),
//                             note: _noteController.text,
//                             isActive: _isActive,
//                           );
//                           int id = await _reminderService.createReminder(reminder);
//                           print('tạo thành công');
//                           reminder.id = id; // Gán ID mới từ cơ sở dữ liệu vào đối tượng reminder
//                           Navigator.pop(context, reminder);  // Truyền đối tượng mới tạo về màn hình trước
//                         }
//                       },
//                       text: 'Tạo',
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   _selectDate() async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _startDate,
//       firstDate: DateTime.now(
//
//       ),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != _startDate)
//       setState(() {
//         _startDate = picked;
//       });
//   }
//
//   _selectTime() async {
//     TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _time,
//       builder: (BuildContext context, Widget? child) {
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != _time) {
//       setState(() {
//         _time = picked;
//       });
//     }
//   }
//
// // Đảm bảo rằng bạn đã cập nhật nút "Tạo" với logic kiểm tra thời gian
// }
