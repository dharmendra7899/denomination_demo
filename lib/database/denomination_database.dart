import 'package:denomination/database/denomination_data_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DenominationDatabaseHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'records.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE records(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            totalAmount REAL,
            fileName TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertRecord(DenominationDataModel record) async {
    final dbClient = await db;
    await dbClient.insert('records', record.toMap());
  }

  static Future<List<DenominationDataModel>> getRecords() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'records',
      orderBy: 'id DESC',
    );
    return maps.map((e) => DenominationDataModel.fromMap(e)).toList();
  }

  static Future<void> deleteRecord(int id) async {
    final dbClient = await db;
    await dbClient.delete('records', where: 'id = ?', whereArgs: [id]);
  }
}
