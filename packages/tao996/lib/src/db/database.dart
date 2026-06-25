/// IDatabaseService 接口（供 Repository 使用）。
/// 实际实现在 tao996_flutter 层（使用 sqflite）。
abstract class IDatabaseService {
  Future<List<Map<String, dynamic>>> query(String sql, [List<Object?>? args]);

  Future<int> execute(String sql, [List<Object?>? args]);

  Future<void> executeBatch(List<SqlStatement> statements);

  Future<void> close();
}

class SqlStatement {
  final String sql;
  final List<Object?>? args;

  SqlStatement(this.sql, [this.args]);
}
