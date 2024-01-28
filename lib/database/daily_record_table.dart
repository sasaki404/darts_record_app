import 'package:darts_record_app/database/database_manager.dart';
import 'package:darts_record_app/model/daily_record.dart';
import 'package:sqflite/sqflite.dart';

class DailyRecordTable {
  final tableName = 'DAILY_RECORD';

  // DAILY_RECORDテーブルを作成する
  Future<void> createTable(Database db) async {
    final sql = """
      CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER NOT NULL,
        "user_id" INTEGER NOT NULL,
        "count_map" TEXT NOT NULL,
        "target_date" TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
      );
    """;
    await db.execute(sql);
  }

  Future<int> insert(
      {required int userId, required Map<String, int> countMap}) async {
    final db = await DatabaseManager().database;
    final sql = '''
      INSERT INTO $tableName (user_id, count_map, target_date) VALUES (?, ?, ?) 
    ''';
    DateTime now = DateTime.now();
    return await db.rawInsert(sql, [
      userId,
      DailyRecord.countMapToStr(countMap),
      "${now.year}-${now.month}-${now.day}"
    ]);
  }

  Future<void> update(
      {required int userId,
      required Map<String, int> countMap,
      required DateTime now}) async {
    final db = await DatabaseManager().database;
    final sql = '''
      UPDATE $tableName set count_map=? WHERE user_id=? and target_date=?
    ''';
    await db.rawQuery(sql, [
      DailyRecord.countMapToStr(countMap),
      userId,
      "${now.year}-${now.month}-${now.day}"
    ]);
  }

  Future<List<DailyRecord>> selectAll(int userId) async {
    final db = await DatabaseManager().database;
    final sql = '''
        SELECT * from $tableName WHERE user_id = ?
    ''';
    final res = await db.rawQuery(sql, [userId]);
    return res.map((e) => DailyRecord.fromSqfliteDatabase(e)).toList();
  }

  Future<List<DailyRecord>> selectByUserId(
      int userId, DateTime targetDate) async {
    final db = await DatabaseManager().database;
    final sql = '''
        SELECT * from $tableName WHERE user_id = ? and target_date = ?
    ''';
    final res =
        await db.rawQuery(sql, [userId, DailyRecord.toTargetDate(targetDate)]);
    return res.map((e) => DailyRecord.fromSqfliteDatabase(e)).toList();
  }

  Future<void> delete(int id) async {
    final db = await DatabaseManager().database;
    final sql = '''
      DELETE FROM $tableName WHERE id = ?
    ''';
    await db.rawDelete(sql, [id]);
  }
}
