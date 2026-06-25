import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tao996/tao996.dart';

/// 类型转换工具 — 安全地在常见类型之间做转换。
class MyCastUtil {
  MyCastUtil._();

  /// 转为 String，非 String 类型返回 [defaultValue]。
  static String asString(dynamic value, {String defaultValue = ''}) {
    if (value is String) return value;
    if (value != null) return value.toString();
    return defaultValue;
  }

  /// 转为 int。
  static int asInt(dynamic value, {int defaultValue = 0}) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    if (value is bool) return value ? 1 : 0;
    return defaultValue;
  }

  /// 转为 double。
  static double asDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// 转为 bool。
  static bool asBool(dynamic value, {bool defaultValue = false}) {
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
  static List<T> asList<T>(dynamic value, T Function(dynamic) castItem) {
    if (value is! List) return [];
    return value.map((e) => castItem(e)).toList();
  }

  /// 严格类型过滤 — 只保留类型为 `[T]` 的元素，跳过不匹配的。
  ///
  /// ```dart
  /// final nums = cast.asListStrict<int>([1, 'a', 2, null, 3]); // [1, 2, 3]
  /// ```
  static List<T> asListStrict<T>(dynamic value) {
    if (value is! List) return [];
    return value.whereType<T>().toList();
  }

  /// 嵌套 List 展平并转换。
  ///
  /// ```dart
  /// final flat = cast.asListFlat<int>([[1, 2], [3, 4]]); // [1, 2, 3, 4]
  /// ```
  static List<T> asListFlat<T>(dynamic value) {
    if (value is! List) return [];
    return value
        .expand((e) => e is List ? e.whereType<T>() : [e])
        .whereType<T>()
        .toList();
  }

  /// 转为 `Map<String, dynamic>`。
  static Map<String, dynamic> asMap(
    dynamic value, {
    Map<String, dynamic>? defaultValue,
  }) {
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v));
    }
    return defaultValue ?? const {};
  }

  /// 安全的向下转型 — value is T 时返回 value，否则返回 `null`。
  static T? tryCast<T>(dynamic value) {
    if (value is T) return value;
    return null;
  }

  /// 强制转型 — 不满足时返回 [defaultValue]。
  static T forceCast<T>(dynamic value, T defaultValue) {
    if (value is T) return value;
    return defaultValue;
  }

  /// 尝试将 String 解析为 num，支持 int 和 double。
  static num? tryParseNum(String value) {
    return int.tryParse(value) ?? double.tryParse(value);
  }

  /// A generic helper to safely cast a map from dynamic to a specific type
  static Map<K, V> castMap<K, V>(dynamic data) {
    if (data is Map) {
      return data.cast<K, V>();
    }
    return {};
  }

  // 私有辅助函数：安全地解码 JSON 字符串
  static dynamic safeJsonDecode(String? jsonString, {required bool isList}) {
    if (jsonString == null || jsonString.isEmpty) {
      return isList ? [] : {};
    }
    try {
      final decoded = jsonDecode(jsonString);
      // 根据预期类型进行初步检查
      if ((isList && decoded is List) || (!isList && decoded is Map)) {
        return decoded;
      }
    } on FormatException catch (e) {
      if (kDebugMode) {
        debugPrint('Invalid JSON format: $e');
      }
    } on TypeError catch (e) {
      if (kDebugMode) {
        debugPrint('Type error during JSON decode: $e');
      }
    }
    return isList ? [] : {};
  }

  /// 安全解析 JSON 字符串，失败返回 null。
  static dynamic tryJsonDecode(String json) {
    try {
      return jsonDecode(json);
    } catch (_) {
      return null;
    }
  }

  /// 安全解析 JSON 字符串为 Map。
  static Map<String, dynamic>? mapDynamicJsonDecode(String jsonString) {
    final result = tryJsonDecode(jsonString);
    if (result is Map<String, dynamic>) return result;
    return null;
  }

  /// 将 json string 还原为 `Map<String,String>`
  static Map<String, String> mapStringJsonDecode(String? jsonString) {
    final dynamic decoded = safeJsonDecode(jsonString, isList: false);
    return MyCastUtil.castMap<String, String>(decoded);
  }

  /// 将 json string 还原为 `Map<String,int>`
  static Map<String, int> mapIntJsonDecode(String? jsonString) {
    final dynamic decoded = safeJsonDecode(jsonString, isList: false);
    return MyCastUtil.castMap<String, int>(decoded);
  }

  static Map<String, double> mapDoubleJsonDecode(String? jsonString) {
    final dynamic decoded = safeJsonDecode(jsonString, isList: false);
    return MyCastUtil.castMap<String, double>(decoded);
  }

  static Map<String, bool> mapBoolJsonDecode(String? jsonString) {
    final dynamic decoded = safeJsonDecode(jsonString, isList: false);
    return MyCastUtil.castMap<String, bool>(decoded);
  }

  /// 将 map 转为 json string
  static String tryJsonEncode(Map<String, dynamic>? map) {
    if (map == null) {
      return "{}";
    }
    return jsonEncode(map);
  }

  /// 安全解析 JSON 字符串为 List。
  static List<dynamic>? listJsonDecode(String json) {
    final result = tryJsonDecode(json);
    if (result is List) return result;
    return null;
  }

  /// 将 JSON 字符串转为 `List<T>`
  static List<T> listJsonDecodeWith<T>(
    String? jsonString,
    T Function(Map<String, dynamic>) fromMap,
  ) {
    final decoded = safeJsonDecode(jsonString, isList: true);
    if (decoded is List) {
      // 安全地映射和转换
      return decoded
          .whereType<Map>()
          .map((e) => fromMap(e.cast<String, dynamic>()))
          .toList();
    }
    return [];
  }

  /// 将 `List<T>` 转为 JSON 字符串
  static String listJsonEncode<T>(
    List<T>? list,
    Map<String, dynamic> Function(T) toMap,
  ) {
    if (list == null || list.isEmpty) return '[]';
    final mapList = listToListMap(list, toMap);
    return jsonEncode(mapList);
  }

  /// 格式化 JSON 为缩进字符串（用于调试输出）。
  static String prettyPrintJson(dynamic data) {
    final encoder = const JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  }

  /// 深合并两个 Map — [source] 覆盖 [target]。
  /// 嵌套 Map 递归合并。
  static Map<String, dynamic> mapDeepMerge(
    Map<String, dynamic> target,
    Map<String, dynamic> source,
  ) {
    final result = Map<String, dynamic>.from(target);
    for (final entry in source.entries) {
      if (result[entry.key] is Map<String, dynamic> &&
          entry.value is Map<String, dynamic>) {
        result[entry.key] = mapDeepMerge(
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
    final map = tryJsonDecode(json);
    if (map == null) return defaultValue;
    return getByPath(map, path, defaultValue: defaultValue);
  }

  /// 过滤掉 Map 中值为 null 的键。
  static Map<String, dynamic> filter(Map<String, dynamic> data) {
    return Map.fromEntries(data.entries.where((e) => e.value != null));
  }

  /// 将 `List<T>` 转为 `List<Map<String, dynamic>>`
  static List<Map<String, dynamic>> listToListMap<T>(
    List<T>? list,
    Map<String, dynamic> Function(T) toMap,
  ) {
    if (list == null || list.isEmpty) return [];
    return list.map(toMap).toList();
  }

  /// and handling element-level type casting.
  static List<T> castList<T>(
    dynamic data,
    T Function(dynamic) converter, {
    bool throwOnError = true,
  }) {
    if (data == null) {
      return [];
    }
    if (data is! List) {
      if (throwOnError) {
        throw ArgumentError('${data.runtimeType}'.mustList);
      }
      if (kDebugMode) {
        debugPrint('Error: Expected a List but got ${data.runtimeType}');
      }
      return [];
    }
    try {
      return data.map<T>(converter).toList();
    } catch (e) {
      if (throwOnError) {
        throw ArgumentError('Error parsing List<${T.toString()}>: $e');
      }
      return [];
    }
  }

  static List<int> listIntFromDynamicList(
    dynamic data, {
    bool throwOnError = true,
  }) {
    return castList<int>(
      data,
      (e) => (e as num).toInt(),
      throwOnError: throwOnError,
    );
  }

  static List<double> listDoubleFromDynamicList(
    dynamic data, {
    bool throwOnError = true,
  }) {
    return castList<double>(
      data,
      (e) => (e as num).toDouble(),
      throwOnError: throwOnError,
    );
  }

  static List<String> listStringFromDynamicList(
    dynamic data, {
    bool throwOnError = true,
  }) {
    return castList<String>(
      data,
      (e) => (e as String).toString(),
      throwOnError: throwOnError,
    );
  }

  static Map<String, Map<String, String>> stringToNestedMap(String jsonString) {
    // 1. 先解析为原始 Map
    final dynamic rawData = jsonDecode(jsonString);

    // 2. 显式转换为嵌套结构
    if (rawData is Map) {
      return rawData.map((key, value) {
        return MapEntry(
          key.toString(),
          // 关键点：将内部的 dynamic Map 转换为 Map<String, String>
          Map<String, String>.from(value as Map),
        );
      });
    }

    return {};
  }
}
