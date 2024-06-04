// import '../database/database_helper.dart';
// import '../model/category_model.dart';
//
//
// class CategoryService {
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//
//   Future<int> createCategory(Category category) async {
//     final db = await _dbHelper.database;
//     return await db.insert('categories', category.toMap());
//   }
//
//   Future<List<Category>> getIncomeCategories() async {
//     final db = await _dbHelper.database;
//     final List<Map<String, dynamic>> maps = await db.query('categories', where: 'type = ?', whereArgs: ['income']);
//     return List.generate(maps.length, (i) {
//       return Category.fromMap(maps[i]);
//     });
//   }
//
//   Future<List<Category>> getExpenseCategories() async {
//     final db = await _dbHelper.database;
//     final List<Map<String, dynamic>> maps = await db.query('categories', where: 'type = ?', whereArgs: ['expense']);
//     return List.generate(maps.length, (i) {
//       return Category.fromMap(maps[i]);
//     });
//   }
//
//   Future<int> updateCategory(Category category) async {
//     final db = await _dbHelper.database;
//     return await db.update('categories', category.toMap(), where: 'id = ?', whereArgs: [category.id]);
//   }
//
//   Future<int> deleteCategory(int id) async {
//     final db = await _dbHelper.database;
//     return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
//   }
// }
