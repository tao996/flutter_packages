import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart' as p;
import 'package:tao996/tao996.dart';

/// Sqflite 数据库服务 — IDatabaseService 的实现。
///
/// 使用 sqflite 在本地文件系统中创建和管理 SQLite 数据库。
///
/// 使用方式:
/// ```dart
/// final db = SqfliteDatabaseService(
///   databaseDir: await getDatabaseDir(),
///   databaseName: 'jbook.db',
/// );
/// await db.migrate((path) async {
///   return await openDatabase(path, version: 1,
///     onCreate: (db, version) async { ... },
///   );
/// });
/// locator.registerSingleton<IDatabaseService>(db);
/// ```
class SqfliteDatabaseService implements IDatabaseService {
  sqflite.Database? _database;
  final String databasePath;
  final bool printSQL;

  SqfliteDatabaseService({
    required String databaseDir,
    String databaseName = 'app.db',
    this.printSQL = false,
  }) : databasePath = p.join(databaseDir, databaseName);

  /// 获取底层数据库实例。
  sqflite.Database get database {
    if (_database == null) {
      throw StateError('Database not opened. Call migrate() first.');
    }
    return _database!;
  }

  /// 打开/迁移数据库。
  ///
  /// [factory] 接收数据库文件路径，返回已打开的 Database 实例。
  /// 通常配合 `openDatabase()` 使用。
  Future<void> migrate(
    Future<sqflite.Database> Function(String path) factory,
  ) async {
    _database = await factory(databasePath);
  }

  @override
  Future<void> close() async {
    await _database?.close();
    _database = null;
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String sql, [
    List<Object?>? args,
  ]) async {
    _log(sql, args);
    return await database.rawQuery(sql, args);
  }

  @override
  Future<int> execute(String sql, [List<Object?>? args]) async {
    _log(sql, args);
    final upper = sql.trimLeft().toUpperCase();
    if (upper.startsWith('INSERT')) {
      // rawInsert returns the new row's id (last_insert_rowid)
      return await database.rawInsert(sql, args);
    }
    // UPDATE / DELETE / DDL: return affected row count
    return await database.rawUpdate(sql, args);
  }

  @override
  Future<void> executeBatch(List<SqlStatement> statements) async {
    final batch = database.batch();
    for (final stmt in statements) {
      _log(stmt.sql, stmt.args);
      // execute works for any SQL statement (INSERT / UPDATE / DELETE / DDL)
      batch.execute(stmt.sql, stmt.args);
    }
    await batch.commit(noResult: true);
  }

  void _log(String sql, List<Object?>? args) {
    if (printSQL) {
      // ignore: avoid_print
      print('[DB] $sql ${args != null ? args.toString() : ''}');
    }
  }
}
