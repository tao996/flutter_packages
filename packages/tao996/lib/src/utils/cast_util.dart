/// 类型转换工具 — 安全地在常见类型之间做转换。
class CastUtil {
  const CastUtil();

  /// 转为 String，非 String 类型返回 [defaultValue]。
  String asString(dynamic value, {String defaultValue = ''}) {
    if (value is String) return value;
    if (value != null) return value.toString();
    return defaultValue;
  }

  /// 转为 int。
  int asInt(dynamic value, {int defaultValue = 0}) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    if (value is bool) return value ? 1 : 0;
    return defaultValue;
  }

  /// 转为 double。
  double asDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// 转为 bool。
  bool asBool(dynamic value, {bool defaultValue = false}) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final lower = value.trim().toLowerCase();
      if (lower == 'true' || lower == '1' || lower == 'yes') return true;
      if (lower == 'false' || lower == '0' || lower == 'no') return false;
    }
    return defaultValue;
  }

  /// 转为 `List<T>`，使用转换函数逐个处理元素。
  List<T> asList<T>(dynamic value, T Function(dynamic) castItem) {
    if (value is! List) return [];
    return value.map((e) => castItem(e)).toList();
  }

  /// 严格类型过滤 — 只保留类型为 `[T]` 的元素，跳过不匹配的。
  ///
  /// ```dart
  /// final nums = cast.asListStrict<int>([1, 'a', 2, null, 3]); // [1, 2, 3]
  /// ```
  List<T> asListStrict<T>(dynamic value) {
    if (value is! List) return [];
    return value.whereType<T>().toList();
  }

  /// 嵌套 List 展平并转换。
  ///
  /// ```dart
  /// final flat = cast.asListFlat<int>([[1, 2], [3, 4]]); // [1, 2, 3, 4]
  /// ```
  List<T> asListFlat<T>(dynamic value) {
    if (value is! List) return [];
    return value
        .expand((e) => e is List ? e.whereType<T>() : [e])
        .whereType<T>()
        .toList();
  }

  /// 转为 `Map<String, dynamic>`。
  Map<String, dynamic> asMap(
    dynamic value, {
    Map<String, dynamic>? defaultValue,
  }) {
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v));
    }
    return defaultValue ?? const {};
  }

  /// 安全的向下转型 — value is T 时返回 value，否则返回 `null`。
  T? tryCast<T>(dynamic value) {
    if (value is T) return value;
    return null;
  }

  /// 强制转型 — 不满足时返回 [defaultValue]。
  T forceCast<T>(dynamic value, T defaultValue) {
    if (value is T) return value;
    return defaultValue;
  }

  /// 尝试将 String 解析为 num，支持 int 和 double。
  num? tryParseNum(String value) {
    return int.tryParse(value) ?? double.tryParse(value);
  }
}
