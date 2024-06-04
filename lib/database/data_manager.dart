// import '../model/category_model.dart';
// import '../model/reminder_model.dart';
// import '../model/transaction_model.dart';
// import 'database_helper.dart';
//
// class DataManager {
//   static final DataManager _instance = DataManager._internal();
//   factory DataManager() => _instance;
//   DataManager._internal();
//
//   // CRUD for Categories
//   Future<int> createCategory(Category category) async {
//     final db = await DatabaseHelper().database;
//     return await db.insert('Categories', category.toMap());
//   }
//
//   Future<List<Category>> readCategories(String type) async {
//     final db = await DatabaseHelper().database;
//     final List<Map<String, dynamic>> maps = await db.query('Categories', where: 'type = ?', whereArgs: [type]);
//     return List.generate(maps.length, (i) {
//       return Category.fromMap(maps[i]);
//     });
//   }
//
//   Future<int> updateCategory(Category category) async {
//     final db = await DatabaseHelper().database;
//     return await db.update(
//       'Categories',
//       category.toMap(),
//       where: 'id = ?',
//       whereArgs: [category.id],
//     );
//   }
//
//   Future<int> deleteCategory(int id) async {
//     final db = await DatabaseHelper().database;
//     return await db.delete(
//       'Categories',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
//
//   // CRUD for Transactions
//   Future<int> createTransaction(Transaction transaction) async {
//     final db = await DatabaseHelper().database;
//     return await db.insert('Transactions', transaction.toMap());
//   }
//
//   Future<List<Transaction>> readTransactions() async {
//     final db = await DatabaseHelper().database;
//     final List<Map<String, dynamic>> maps = await db.query('Transactions');
//     return List.generate(maps.length, (i) {
//       return Transaction.fromMap(maps[i]);
//     });
//   }
//
//   Future<int> updateTransaction(Transaction transaction) async {
//     final db = await DatabaseHelper().database;
//     return await db.update(
//       'Transactions',
//       transaction.toMap(),
//       where: 'id = ?',
//       whereArgs: [transaction.id],
//     );
//   }
//
//   Future<int> deleteTransaction(int id) async {
//     final db = await DatabaseHelper().database;
//     return await db.delete(
//       'Transactions',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
//
//   // CRUD for Reminders
//   Future<int> createReminder(Reminder reminder) async {
//     final db = await DatabaseHelper().database;
//     return await db.insert('Reminders', reminder.toMap());
//   }
//
//   Future<List<Reminder>> readReminders() async {
//     final db = await DatabaseHelper().database;
//     final List<Map<String, dynamic>> maps = await db.query('Reminders');
//     return List.generate(maps.length, (i) {
//       return Reminder.fromMap(maps[i]);
//     });
//   }
//
//   Future<int> updateReminder(Reminder reminder) async {
//     final db = await DatabaseHelper().database;
//     return await db.update(
//       'Reminders',
//       reminder.toMap(),
//       where: 'id = ?',
//       whereArgs: [reminder.id],
//     );
//   }
//
//   Future<int> deleteReminder(int id) async {
//     final db = await DatabaseHelper().database;
//     return await db.delete(
//       'Reminders',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
// }
