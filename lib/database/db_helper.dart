import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food_model.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'food_journal.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE foods (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama_makanan TEXT,
            foto TEXT,
            tanggal TEXT,
            catatan TEXT
          )
        ''');
      },
    );
  }

  static Future<int> insertFood(FoodModel food) async {
    final db = await database;
    return await db.insert('foods', food.toMap());
  }

  static Future<List<FoodModel>> getFoods() async {
    final db = await database;
    final result = await db.query(
      'foods',
      orderBy: 'id DESC',
    );

    return result.map((e) => FoodModel.fromMap(e)).toList();
  }

  static Future<int> updateFood(FoodModel food) async {
    final db = await database;
    return await db.update(
      'foods',
      food.toMap(),
      where: 'id = ?',
      whereArgs: [food.id],
    );
  }

  static Future<int> deleteFood(int id) async {
    final db = await database;
    return await db.delete(
      'foods',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}