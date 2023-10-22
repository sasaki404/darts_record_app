import 'package:darts_record_app/database/database_manager.dart';
import 'package:darts_record_app/model/user_info.dart';
import 'package:sqflite/sqflite.dart';

class UserInfoTable {
  final tableName = 'USER_INFO';

  // COUNT_UP_RECORDテーブルを作成する
  Future<void> createTable(Database db) async {
    final sql = """
      CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER NOT NULL,
        "name" TEXT NOT NULL,
        "rating" REAL NOT NULL DEFAULT 0,
        "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') as integer)),
        "updated_at" INTEGER,
        PRIMARY KEY("id" AUTOINCREMENT)
      );
    """;
    await db.execute(sql);
  }

  Future<int> insert(String name) async {
    final db = await DatabaseManager().database;
    final sql = '''
      INSERT INTO $tableName (name, created_at) VALUES (?, ?)
    ''';
    return await db
        .rawInsert(sql, [name, DateTime.now().millisecondsSinceEpoch]);
  }

  Future<List<UserInfo>> selectAll() async {
    final db = await DatabaseManager().database;
    final sql = '''
        SELECT * from $tableName ORDER BY COALESCE(updated_at, created_at) DESC
    ''';
    final res = await db.rawQuery(sql);
    return res.map((e) => UserInfo.fromSqfliteDatabase(e)).toList();
  }

  Future<UserInfo> selectById(int id) async {
    final db = await DatabaseManager().database;
    final sql = '''
        SELECT * from $tableName WHERE id = ?
    ''';
    final res = await db.rawQuery(sql, [id]);
    return UserInfo.fromSqfliteDatabase(res.first);
  }

  Future<UserInfo> update(UserInfo info) async {
    final db = await DatabaseManager().database;
    final sql = '''
        UPDATE $tableName set name = ?, rating = ? WHERE id = ?
    ''';
    final res = await db.rawQuery(sql, [info.name, info.rating, info.id]);
    return UserInfo.fromSqfliteDatabase(res.first);
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
