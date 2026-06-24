/// SQL 查询构建器 — 构建 WHERE / ORDER BY / LIMIT / OFFSET 子句。
///
/// 使用方式:
/// ```dart
/// final qb = QueryBuilder()
///   ..where('name LIKE ?', ['%张三%'])
///   ..orderBy('createdAt DESC')
///   ..limit(10)
///   ..offset(0);
/// final sql = qb.build();       // "WHERE name LIKE ? ORDER BY createdAt DESC LIMIT 10 OFFSET 0"
/// final args = qb.whereArgs;   // ['%张三%']
/// ```
class QueryBuilder {
  final List<String> _conditions = [];
  final List<Object?> _args = [];
  String? _orderBy;
  int? _limit;
  int? _offset;

  /// 添加 WHERE 条件。
  /// [condition] 如 `"name LIKE ?"`，[arg] 是对应的参数值。
  QueryBuilder where(String condition, [Object? arg]) {
    _conditions.add(condition);
    if (arg != null) {
      if (arg is List) {
        _args.addAll(arg);
      } else {
        _args.add(arg);
      }
    }
    return this;
  }

  /// 添加可选条件 — 只有 [condition] 不为空时才添加。
  QueryBuilder whereIf(String condition, [Object? arg]) {
    if (condition.isNotEmpty) {
      where(condition, arg);
    }
    return this;
  }

  /// 设置排序，如 `"createdAt DESC"`。
  QueryBuilder orderBy(String order) {
    _orderBy = order;
    return this;
  }

  /// 设置返回行数上限。
  QueryBuilder limit(int limit) {
    _limit = limit;
    return this;
  }

  /// 设置偏移量（用于分页）。
  QueryBuilder offset(int offset) {
    _offset = offset;
    return this;
  }

  /// 将另一个 QueryBuilder 的条件合并进来（不含 limit/offset）。
  QueryBuilder merge(QueryBuilder other) {
    _conditions.addAll(other._conditions);
    _args.addAll(other._args);
    if (other._orderBy != null) _orderBy = other._orderBy;
    return this;
  }

  /// 构建完整的 WHERE + ORDER BY + LIMIT + OFFSET 子句。
  /// 返回空字符串（无条件时）或如 `"WHERE name LIKE ? ORDER BY createdAt DESC LIMIT 10"`。
  String build() {
    final parts = <String>[];
    if (_conditions.isNotEmpty) {
      parts.add('WHERE ${_conditions.join(' AND ')}');
    }
    if (_orderBy != null && _orderBy!.isNotEmpty) {
      parts.add('ORDER BY $_orderBy');
    }
    if (_limit != null) {
      parts.add('LIMIT $_limit');
    }
    if (_offset != null && _limit != null) {
      parts.add('OFFSET $_offset');
    }
    return parts.join(' ');
  }

  /// WHERE 子句的参数值列表。
  List<Object?> get whereArgs => List.unmodifiable(_args);

  /// 重置构建器。
  void reset() {
    _conditions.clear();
    _args.clear();
    _orderBy = null;
    _limit = null;
    _offset = null;
  }
}
