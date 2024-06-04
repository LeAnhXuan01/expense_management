// import 'package:expense_management/widget/custom_header.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../../main.dart';
// import '../../model/reminder_model.dart';
// import '../../services/reminder_service.dart';
// import 'create_reminder_screen.dart';
// import 'edit_reminder_screen.dart';
// import 'package:timezone/timezone.dart' as tz;
//
//
// class ReminderListScreen extends StatefulWidget {
//   @override
//   _ReminderListScreenState createState() => _ReminderListScreenState();
// }
//
// class _ReminderListScreenState extends State<ReminderListScreen> {
//   final ReminderService _reminderService = ReminderService();
//   List<Reminder> _reminders = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadReminders();
//   }
//
//   Future<void> _loadReminders() async {
//     final reminders = await _reminderService.getReminders();
//     setState(() {
//       _reminders = reminders;
//     });
//   }
//
//   Future<void> _showDeleteAllConfirmationDialog(BuildContext context) async {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Xác nhận xóa'),
//           content: Text('Bạn có chắc chắn muốn xóa tất cả các nhắc nhở không?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Đóng dialog
//               },
//               child: Text('Hủy'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 await _reminderService.deleteAllReminders(); // Xóa tất cả các nhắc nhở
//                 _loadReminders(); // Tải lại danh sách nhắc nhở để cập nhật giao diện
//                 Navigator.of(context).pop(); // Đóng dialog
//               },
//               child: Text('Xóa'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showNoRemindersToDeleteDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Không có nhắc nhở'),
//           content: Text('Không có nhắc nhở nào để xóa.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Đóng dialog
//               },
//               child: Text('Đóng'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _handleDeleteAllReminders(BuildContext context) async {
//     if (_reminders.isEmpty) {
//       _showNoRemindersToDeleteDialog(context);
//     } else {
//       _showDeleteAllConfirmationDialog(context);
//       await flutterLocalNotificationsPlugin.cancelAll(); // Hủy tất cả thông báo
//     }
//   }
//
//   void _scheduleNotification(Reminder reminder) async {
//     final DateTime now = DateTime.now();
//     final DateTime reminderTime = DateTime.parse(reminder.startDate!).add(
//       Duration(
//         hours: int.parse(reminder.reminderTime!.split(':')[0]),
//         minutes: int.parse(reminder.reminderTime!.split(':')[1]),
//       ),
//     );
//
//     if (reminder.isActive && reminderTime.isAfter(now)) {
//       const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'your_channel_id',
//         'your_channel_name',
//         channelDescription: 'your_channel_description',
//         importance: Importance.max,
//         priority: Priority.high,
//         showWhen: false,
//       );
//       const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         reminder.id.hashCode, // Unique notification ID
//         'Lời nhắc',
//         reminder.name,
//         tz.TZDateTime.from(reminderTime, tz.local), // Convert to TZDateTime
//         platformChannelSpecifics,
//         androidAllowWhileIdle: true, // Optional, depending on your requirements
//         uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
//       );
//     }
//   }
//
//
//   void _addReminder(Reminder reminder) {
//     setState(() {
//       _reminders.add(reminder);
//     });
//     _scheduleNotification(reminder);
//   }
//
//   void _updateReminder(Reminder reminder) {
//     setState(() {
//       int index = _reminders.indexWhere((r) => r.id == reminder.id);
//       if (index != -1) {
//         _reminders[index] = reminder;
//       }
//     });
//     _scheduleNotification(reminder);
//   }
//
//   void _deleteReminder(Reminder reminder) {
//     setState(() {
//       _reminders.removeWhere((r) => r.id == reminder.id);
//     });
//     flutterLocalNotificationsPlugin.cancel(reminder.id.hashCode); // Hủy thông báo khi xóa lời nhắc
//   }
//
//   // void _deleteAllReminders() async {
//   //   await _reminderService.deleteAllReminders();
//   //   _loadReminders(); // Load lại danh sách sau khi xóa
//   // }
//
//   // Future<void> _toggleReminderActive(Reminder reminder) async {
//   //   reminder.isActive = !reminder.isActive;
//   //   await _reminderService.updateReminder(reminder);
//   //   setState(() {});
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           CustomHeader(
//             title: 'Danh sách lời nhắc',
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.delete, color: Colors.white),
//                 onPressed: () {
//                   _handleDeleteAllReminders(context);
//                 },
//                 tooltip: 'Xóa tất cả nhắc nhở',
//               ),
//             ],
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _reminders.length,
//               itemBuilder: (context, index) {
//                 final reminder = _reminders[index];
//                 return Dismissible(
//                   key: Key(reminder.id.toString()),
//                   background: Container(
//                     color: Colors.red,
//                     alignment: Alignment.centerLeft,
//                     child: Icon(
//                       Icons.delete,
//                       color: Colors.white,
//                     ),
//                   ),
//                   // secondaryBackground: Container(
//                   //   color: Colors.green,
//                   //   alignment: Alignment.centerRight,
//                   //   child: Icon(
//                   //     Icons.delete,
//                   //     color: Colors.white,
//                   //   ),
//                   // ),
//                   onDismissed: (direction) {
//                     _deleteReminder(reminder); // Xóa lời nhắc khi bị vuốt
//                   },
//                   child: ListTile(
//                     title: Text(reminder.name ?? ''),
//                     trailing: Switch(
//                       value: reminder.isActive,
//                       onChanged: (value) {
//                         setState(() {
//                           reminder.isActive = value;
//                           _reminderService.updateReminder(reminder); // Cập nhật trạng thái hoạt động trong DB
//                         });
//                       },
//                     ),
//                     onTap: () async {
//                       final result = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EditReminderScreen(reminder: reminder),
//                         ),
//                       );
//                       if (result != null) {
//                         if (result['action'] == 'update') {
//                           _updateReminder(result['reminder']);
//                         } else if (result['action'] == 'delete') {
//                           _deleteReminder(result['reminder']);
//                         }
//                       }
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//         floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CreateReminderScreen(),
//             ),
//           );
//           if (result != null) {
//             _addReminder(result as Reminder);
//           }
//         },
//       ),
//     );
//   }
// }
