// import 'package:flutter/material.dart';
// import '../model/reminder_model.dart';
// import '../services/reminder_service.dart';
//
// class ReminderViewModel extends ChangeNotifier {
//   List<Reminder> _reminders = [];
//   List<Reminder> get reminders => _reminders;
//
//   final ReminderService _reminderService = ReminderService();
//
//   // Load reminders from the database
//   void loadReminders() async {
//     _reminders = await _reminderService.getReminders();
//     notifyListeners();
//   }
//
//   // Add a new reminder to the database
//   void createReminder(Reminder reminder) async {
//     int id = await _reminderService.createReminder(reminder);
//     reminder.id = id;
//     _reminders.add(reminder);
//     notifyListeners();
//   }
//
//   // Update an existing reminder in the database
//   void updateReminder(Reminder reminder) async {
//     await _reminderService.updateReminder(reminder);
//     int index = _reminders.indexWhere((r) => r.id == reminder.id);
//     _reminders[index] = reminder;
//     notifyListeners();
//   }
//
//   // Delete a reminder from the database
//   void deleteReminder(int id) async {
//     await _reminderService.deleteReminder(id);
//     _reminders.removeWhere((r) => r.id == id);
//     notifyListeners();
//   }
// }
