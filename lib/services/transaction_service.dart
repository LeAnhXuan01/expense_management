// import '../database/database_helper.dart';
// import '../model/transaction_model.dart';
// import '../model/category_model.dart';
//
// class TransactionService {
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//
//   Future<int> createTransaction(Transaction transaction) async {
//     final db = await _dbHelper.database;
//     return await db.insert('transactions', transaction.toMap());
//   }
//
//   Future<List<Transaction>> getTransactions() async {
//     final db = await _dbHelper.database;
//     final List<Map<String, dynamic>> maps = await db.query('transactions');
//     return List.generate(maps.length, (i) {
//       return Transaction.fromMap(maps[i]);
//     });
//   }
//
//   Future<Category?> getCategoryById(int id) async {
//     final db = await _dbHelper.database;
//     final List<Map<String, dynamic>> maps = await db.query(
//       'categories',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (maps.isNotEmpty) {
//       return Category.fromMap(maps.first);
//     } else {
//       return null;
//     }
//   }
//
//   Future<int> updateTransaction(Transaction transaction) async {
//     final db = await _dbHelper.database;
//     return await db.update('transactions', transaction.toMap(), where: 'id = ?', whereArgs: [transaction.id]);
//   }
//
//   Future<int> deleteTransaction(int id) async {
//     final db = await _dbHelper.database;
//     return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
//   }
// }
