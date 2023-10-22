import 'package:darts_record_app/database/database_manager.dart';
import 'package:darts_record_app/model/count_up_record.dart';
import 'package:sqflite/sqflite.dart';

class CountUpRecordTable {
  final tableName = 'COUNT_UP_RECORD';

  // COUNT_UP_RECORDテーブルを作成する
  Future<void> createTable(Database db) async {
    final sql = """
      CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER NOT NULL,
        "user_id" INTEGER NOT NULL,
        "score" INTEGER NOT NULL,
        "score_list" TEXT NOT NULL,
        "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') as integer)),
        "updated_at" INTEGER,
        PRIMARY KEY("id" AUTOINCREMENT)
      );
    """;
    await db.execute(sql);
  }

  Future<int> insert(
      {required int userId,
      required int score,
      required List<int> scoreList}) async {
    final db = await DatabaseManager().database;
    final sql = '''
      INSERT INTO $tableName (user_id, score, score_list, created_at) VALUES (?, ?, ?, ?)
    ''';
    return await db.rawInsert(sql, [
      userId,
      score,
      CountUpRecord.scoreListToStr(scoreList),
      DateTime.now().millisecondsSinceEpoch
    ]);
  }

  Future<List<CountUpRecord>> selectAll() async {
    final db = await DatabaseManager().database;
    final sql = '''
        SELECT * from $tableName ORDER BY COALESCE(updated_at, created_at) DESC
    ''';
    final res = await db.rawQuery(sql);
    return res.map((e) => CountUpRecord.fromSqfliteDatabase(e)).toList();
  }

  Future<List<CountUpRecord>> selectByUserId(int userId) async {
    final db = await DatabaseManager().database;
    final sql = '''
        SELECT * from $tableName WHERE user_id = ? ORDER BY COALESCE(updated_at, created_at) DESC
    ''';
    final res = await db.rawQuery(sql, [userId]);
    return res.map((e) => CountUpRecord.fromSqfliteDatabase(e)).toList();
  }

  //Future<int> update({required int id}) async {}

  Future<void> delete(int id) async {
    final db = await DatabaseManager().database;
    final sql = '''
      DELETE FROM $tableName WHERE id = ?
    ''';
    await db.rawDelete(sql, [id]);
  }
}
