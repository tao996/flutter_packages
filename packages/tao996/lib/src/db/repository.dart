import '../reactive/rx_list.dart';
import 'database.dart';
import 'model.dart';
import 'query_builder.dart';

/// 数据库存储库 — 泛型 CRUD + 分页 + 响应式绑定。
///
/// 替代旧的 ModelHelper + ModelAction + ModelDelegate 三层架构。
///
/// 使用方式:
/// ```dart
/// final repo = Repository<Book>(
///   db: databaseService,
///   tableName: 'books',
///   fromJson: Book.fromJson,
///   toJson: (b) => b.toJson(),
/// );
///
/// // 查询
/// final books = await repo.query(qb: QueryBuilder()..orderBy('createdAt DESC'));
///
/// // 绑定到 RxList (响应式)
/// final items = RxList<Book>();
/// await repo.bind(items, qb: QueryBuilder()..orderBy('createdAt DESC'));
/// ```
class MyRepository<T extends IModel> {
  final IDatabaseService db;
  final String tableName;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  MyRepository({
    required this.db,
    required this.tableName,
    required this.fromJson,
    required this.toJson,
  });

  /// 按 ID 查询单条记录。
  Future<T?> getById(int id) async {
    final rows = await db.query(
      'SELECT * FROM $tableName WHERE id = ? AND deletedAt IS NULL',
      [id],
    );
    if (rows.isEmpty) return null;
    return fromJson(rows.first);
  }

  /// 按 ID 列表查询。
  Future<List<T>> getByIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    final placeholders = ids.map((_) => '?').join(',');
    final rows = await db.query(
      'SELECT * FROM $tableName WHERE id IN ($placeholders) AND deletedAt IS NULL',
      ids,
    );
    return rows.map((r) => fromJson(r)).toList();
  }

  /// 查询列表，支持 [MyQueryBuilder] 过滤/排序/分页。
  /// 始终过滤软删除记录（deletedAt IS NULL）。
  Future<List<T>> query({MyQueryBuilder? qb}) async {
    final baseQb = MyQueryBuilder()..where('deletedAt IS NULL');
    if (qb != null) baseQb.merge(qb);
    final sql = 'SELECT * FROM $tableName ${baseQb.build()}';
    final rows = await db.query(sql, baseQb.whereArgs);
    return rows.map((r) => fromJson(r)).toList();
  }

  /// 分页查询。
  Future<PaginatedResult<T>> queryPaginated({
    int page = 1,
    int pageSize = 15,
    MyQueryBuilder? qb,
  }) async {
    // Base filter (no limit/offset) for count
    final countQb = MyQueryBuilder()..where('deletedAt IS NULL');
    if (qb != null) countQb.merge(qb);
    final countSql =
        'SELECT COUNT(*) as cnt FROM $tableName ${countQb.build()}';
    final countRows = await db.query(countSql, countQb.whereArgs);
    final total = (countRows.first['cnt'] as num?)?.toInt() ?? 0;

    // Paginated data
    final dataQb = MyQueryBuilder()..where('deletedAt IS NULL');
    if (qb != null) dataQb.merge(qb);
    dataQb.limit(pageSize).offset((page - 1) * pageSize);
    final sql = 'SELECT * FROM $tableName ${dataQb.build()}';
    final rows = await db.query(sql, dataQb.whereArgs);

    return PaginatedResult<T>(
      items: rows.map((r) => fromJson(r)).toList(),
      total: total,
      page: page,
      pageSize: pageSize,
    );
  }

  /// 插入记录，返回新记录的 ID，并将 ID 回写到 record。
  Future<int> insert(T record) async {
    final json = toJson(record);
    json.remove('id'); // 数据库自增
    json.remove('createdAt');
    json.remove('updatedAt');
    final now = DateTime.now().toIso8601String();

    final columns = <String>[];
    final values = <Object?>[];
    final placeholders = <String>[];
    for (final entry in json.entries) {
      if (entry.value != null) {
        columns.add(entry.key);
        placeholders.add('?');
        values.add(entry.value);
      }
    }
    columns.add('createdAt');
    placeholders.add('?');
    values.add(now);
    columns.add('updatedAt');
    placeholders.add('?');
    values.add(now);

    final sql =
        'INSERT INTO $tableName (${columns.join(',')}) VALUES (${placeholders.join(',')})';
    final newId = await db.execute(sql, values);
    record.id = newId; // 回写 id
    return newId;
  }

  /// 更新记录，返回受影响行数。
  Future<int> update(T record) async {
    final json = toJson(record);
    final now = DateTime.now().toIso8601String();

    final setClauses = <String>[];
    final values = <Object?>[];
    for (final entry in json.entries) {
      if (entry.key == 'id' || entry.key == 'createdAt') continue;
      setClauses.add('${entry.key} = ?');
      if (entry.key == 'updatedAt') {
        values.add(now);
      } else {
        values.add(entry.value);
      }
    }
    values.add(record.id);

    final sql = 'UPDATE $tableName SET ${setClauses.join(', ')} WHERE id = ?';
    return await db.execute(sql, values);
  }

  /// 删除（软删除），返回受影响行数。
  Future<int> delete(int id) async {
    final now = DateTime.now().toIso8601String();
    return await db.execute(
      'UPDATE $tableName SET deletedAt = ? WHERE id = ?',
      [now, id],
    );
  }

  /// 物理删除，返回受影响行数。
  Future<int> hardDelete(int id) async {
    return await db.execute('DELETE FROM $tableName WHERE id = ?', [id]);
  }

  /// 查询列表并绑定到 RxList。
  /// 返回取消绑定的函数。
  Future<void Function()> bind(RxList<T> rxList, {MyQueryBuilder? qb}) async {
    final items = await query(qb: qb);
    rxList.value = items;
    return () {}; // 当前为一次性绑定，后续可扩展为流式监听
  }
}

/// 分页查询结果。
class PaginatedResult<T extends IModel> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;

  PaginatedResult({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => (total / pageSize).ceil();
  bool get hasMore => page < totalPages;
}
