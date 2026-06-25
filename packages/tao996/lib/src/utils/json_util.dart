import 'dart:convert';

/// JSON 工具 — 深合并、路径访问、格式化、安全解析。
class MyJsonUtil {
  MyJsonUtil._();

  /// 安全解析 JSON 字符串，失败返回 null。
  static dynamic tryParse(String json) {
    try {
      return jsonDecode(json);
    } catch (_) {
      return null;
    }
  }

  /// 安全解析 JSON 字符串为 Map。
  static Map<String, dynamic>? tryParseMap(String json) {
    final result = tryParse(json);
    if (result is Map<String, dynamic>) return result;
    return null;
  }

  /// 安全解析 JSON 字符串为 List。
  static List<dynamic>? tryParseList(String json) {
    final result = tryParse(json);
    if (result is List) return result;
    return null;
  }

  /// 格式化 JSON 为缩进字符串（用于调试输出）。
  static String prettyPrint(dynamic data) {
    final encoder = const JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  }

  /// 深合并两个 Map — [source] 覆盖 [target]。
  /// 嵌套 Map 递归合并。
  static Map<String, dynamic> deepMerge(
    Map<String, dynamic> target,
    Map<String, dynamic> source,
  ) {
    final result = Map<String, dynamic>.from(target);
    for (final entry in source.entries) {
      if (result[entry.key] is Map<String, dynamic> &&
          entry.value is Map<String, dynamic>) {
        result[entry.key] = deepMerge(
          result[entry.key] as Map<String, dynamic>,
          entry.value as Map<String, dynamic>,
        );
      } else {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }

  /// 通过点分隔路径获取值，如 `getByPath(data, 'user.address.city')`。
  /// 路径不存在时返回 [defaultValue]。
  static dynamic getByPath(
    Map<String, dynamic> data,
    String path, {
    dynamic defaultValue,
  }) {
    final keys = path.split('.');
    dynamic current = data;

    for (final key in keys) {
      if (current is Map && current.containsKey(key)) {
        current = current[key];
      } else {
        return defaultValue;
      }
    }

    return current;
  }

  /// 通过点分隔路径设置值。
  /// 中间路径不存在时自动创建空 Map。
  static void setByPath(Map<String, dynamic> data, String path, dynamic value) {
    final keys = path.split('.');
    dynamic current = data;

    for (var i = 0; i < keys.length - 1; i++) {
      if (current is! Map) return;
      current.putIfAbsent(keys[i], () => <String, dynamic>{});
      current = current[keys[i]];
    }

    if (current is Map) {
      current[keys.last] = value;
    }
  }

  /// 从 JSON 字符串中提取指定路径的值。
  static dynamic getFromJson(String json, String path, {dynamic defaultValue}) {
    final map = tryParseMap(json);
    if (map == null) return defaultValue;
    return getByPath(map, path, defaultValue: defaultValue);
  }

  /// 过滤掉 Map 中值为 null 的键。
  static Map<String, dynamic> compact(Map<String, dynamic> data) {
    return Map.fromEntries(data.entries.where((e) => e.value != null));
  }
}
