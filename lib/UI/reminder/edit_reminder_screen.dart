// import 'package:expense_management/widget/custom_ElevatedButton_2.dart';
// import 'package:expense_management/widget/custom_header.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../model/reminder_model.dart';
// import '../../services/reminder_service.dart';
//
// class EditReminderScreen extends StatefulWidget {
//   final Reminder reminder;
//
//   EditReminderScreen({required this.reminder});
//
//   @override
//   _EditReminderScreenState createState() => _EditReminderScreenState();
// }
//
// class _EditReminderScreenState extends State<EditReminderScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _noteController = TextEditingController();
//   late String _frequency;
//   late DateTime _startDate;
//   late TimeOfDay _time;
//   final ReminderService _reminderService = ReminderService();
//
//   @override
//   void initState() {
//     super.initState();
//     _titleController.text = widget.reminder.name ?? '';
//     _noteController.text = widget.reminder.note ?? '';
//     _frequency = widget.reminder.frequency ?? 'Một lần';
//     _startDate = DateTime.parse(widget.reminder.startDate!);
//     _time = TimeOfDay(
//       hour: int.parse(widget.reminder.reminderTime!.split(':')[0]),
//       minute: int.parse(widget.reminder.reminderTime!.split(':')[1].split(' ')[0]),
//     );
//     // Sử dụng `TimeOfDay.fromDateTime` để tạo đối tượng `TimeOfDay` từ thời gian được lưu trữ
//     // final timeParts = widget.reminder.reminderTime!.split(':');
//     // final hour = int.parse(timeParts[0]);
//     // final minute = int.parse(timeParts[1]);
//     //
//     // _time = TimeOfDay(hour: hour, minute: minute);
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
//           CustomHeader(
//             title: 'Chỉnh sửa lời nhắc',
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.delete, color: Colors.white,),
//                 onPressed: () async {
//                   final confirm = await showDialog<bool>(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: Text('Xác nhận xóa'),
//                       content: Text('Bạn có chắc chắn muốn xóa lời nhắc này không?'),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(false),
//                           child: Text('Hủy'),
//                         ),
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(true),
//                           child: Text('Xóa'),
//                         ),
//                       ],
//                     ),
//                   );
//                   if (confirm == true) {
//                     await _reminderService.deleteReminder(widget.reminder.id!);
//                     print("xoa thanh cong");
//                     Navigator.pop(context, {'action': 'delete', 'reminder': widget.reminder});
//                   }
//                 },
//               ),
//             ],
//           ),
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
//                       // title: Text('${_startDate.toLocal()}'.split(' ')[0]),
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
//                           final updatedReminder = Reminder(
//                             id: widget.reminder.id,
//                             name: _titleController.text,
//                             frequency: _frequency,
//                             startDate: _startDate.toIso8601String(),
//                             reminderTime: _time.format(context),
//                             note: _noteController.text,
//                             isActive: widget.reminder.isActive,
//                           );
//                           await _reminderService.updateReminder(updatedReminder);
//                           print("cập nhật thành công");
//                           Navigator.pop(context, {'action': 'update', 'reminder': updatedReminder});
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Center(
//                                   child:
//                                   Text('Cập nhật thành công.')),
//                             ),
//                           );
//                         }
//                       },
//                       text: 'Cập nhật',
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
//       firstDate: DateTime.now(),
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
// }
