import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // await _deleteDatabase(); // Xóa cơ sở dữ liệu cũ
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> _deleteDatabase() async {
    final path = join(await getDatabasesPath(), 'expense_manager.db');
    await deleteDatabase(path);
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'expense_manager.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            type TEXT CHECK(type IN ('income', 'expense')) NOT NULL,
            icon TEXT,
            color TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT CHECK(type IN ('income', 'expense')) NOT NULL,
            amount REAL NOT NULL,
            category_id INTEGER,
            date_time TEXT NOT NULL,
            note TEXT,
            image TEXT,
            FOREIGN KEY (category_id) REFERENCES categories (id)
          );
        ''');

        await db.execute('''
        CREATE TABLE reminders (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          frequency TEXT CHECK(frequency IN ('Một lần', 'Mỗi ngày', 'Mỗi tuần', 'Mỗi 2 tuần', 'Mỗi tháng', 'Mỗi 2 tháng', 'Mỗi quý', 'Mỗi 6 tháng', 'Mỗi năm')) NOT NULL DEFAULT 'Một lần',
          start_date TEXT NOT NULL,
          reminder_time TEXT NOT NULL,
          note TEXT,
          is_active INTEGER NOT NULL DEFAULT 1
        );
      ''');
      },
      version: 1,
      // version: 2, // Tăng version để cập nhật cơ sở dữ liệu
      // onUpgrade: (db, oldVersion, newVersion) async {
      //   if (oldVersion < 2) {
      //     await db.execute('ALTER TABLE reminders ADD COLUMN is_active INTEGER NOT NULL DEFAULT 1');
      //   }
      // },
    );
  }

  Future<void> closeDatabase() async {
    final db = await database;
    db.close();
  }
}
