// class Reminder {
//   int id;
//   String name;
//   String frequency;
//   String startDate;
//   String reminderTime;
//   String note;
//   bool isActive;
//
//   Reminder({
//     required this.id,
//     required this.name,
//     required this.frequency,
//     required this.startDate,
//     required this.reminderTime,
//     required this.note,
//     this.isActive = true, // Default to active
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'frequency': frequency,
//       'start_date': startDate,
//       'reminder_time': reminderTime,
//       'note': note,
//       'is_active': isActive ? 1 : 0, // Store as integer for SQLite
//     };
//   }
//
//   factory Reminder.fromMap(Map<String, dynamic> map) {
//     return Reminder(
//       id: map['id'],
//       name: map['name'],
//       frequency: map['frequency'],
//       startDate: map['start_date'],
//       reminderTime: map['reminder_time'],
//       note: map['note'],
//       isActive: map['is_active'] == 1, // Retrieve from integer
//     );
//   }
// }
