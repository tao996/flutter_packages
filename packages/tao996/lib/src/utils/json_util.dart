import 'dart:convert';

import 'package:tao996/tao996.dart';

/// JSON 工具 — 深合并、路径访问、格式化、安全解析。
class JsonUtil {
  const JsonUtil();

  /// 安全解析 JSON 字符串，失败返回 null。
  dynamic tryParse(String json) {
    try {
      return jsonDecode(json);
    } catch (_) {
      return null;
    }
  }

  /// 安全解析 JSON 字符串为 Map。
  Map<String, dynamic>? tryParseMap(String json) {
    final result = tryParse(json);
    if (result is Map<String, dynamic>) return result;
    return null;
  }

  /// 安全解析 JSON 字符串为 List。
  List<dynamic>? tryParseList(String json) {
    final result = tryParse(json);
    if (result is List) return result;
    return null;
  }

  /// 格式化 JSON 为缩进字符串（用于调试输出）。
  String prettyPrint(dynamic data) {
    final encoder = const JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  }

  /// 深合并两个 Map — [source] 覆盖 [target]。
  /// 嵌套 Map 递归合并。
  Map<String, dynamic> deepMerge(
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
  dynamic getByPath(
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
  void setByPath(Map<String, dynamic> data, String path, dynamic value) {
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
  dynamic getFromJson(String json, String path, {dynamic defaultValue}) {
    final map = tryParseMap(json);
    if (map == null) return defaultValue;
    return getByPath(map, path, defaultValue: defaultValue);
  }

  /// 过滤掉 Map 中值为 null 的键。
  Map<String, dynamic> compact(Map<String, dynamic> data) {
    return Map.fromEntries(data.entries.where((e) => e.value != null));
  }
}

/// JSON Schema 校验器 — 轻量 JSON 结构校验。
///
/// ```dart
/// final schema = JsonSchema({
///   'name': JsonField.string(required: true),
///   'age': JsonField.int(min: 0, max: 150),
///   'email': JsonField.string(pattern: r'^[\w.+-]+@[\w-]+\.[\w]+$'),
/// });
///
/// final result = schema.validate({'name': '张三', 'age': 25});
/// result.isValid  // true
/// ```
class JsonSchema {
  final Map<String, JsonField> fields;

  const JsonSchema(this.fields);

  /// 校验 JSON 数据，返回 [SchemaResult]。
  SchemaResult validate(Map<String, dynamic> data) {
    final errors = <String>[];

    for (final entry in fields.entries) {
      final key = entry.key;
      final field = entry.value;
      final value = data[key];

      // 必填检查
      if (field.required &&
          (value == null || (value is String && value.trim().isEmpty))) {
        errors.add(key.mustRequired);
        continue;
      }

      if (value == null) continue;

      // 类型检查
      switch (field.type) {
        case SchemaFieldType.string:
          if (value is! String) {
            errors.add(key.mustString);
          } else if (field.pattern != null &&
              !RegExp(field.pattern!).hasMatch(value)) {
            errors.add(key.errorPattern);
          }
        case SchemaFieldType.int:
          if (value is! int) {
            errors.add(key.mustInteger);
          } else {
            if (field.min != null && value < field.min!) {
              errors.add(key.mustNotLessThen(field.min));
            }
            if (field.max != null && value > field.max!) {
              errors.add(key.mustNotGreatThen(field.max));
            }
          }
        case SchemaFieldType.double:
          if (value is! num) {
            errors.add(key.mustInteger);
          } else {
            final num = value.toDouble();
            if (field.min != null && num < field.min!) {
              errors.add(key.mustNotLessThen(field.min));
            }
            if (field.max != null && num > field.max!) {
              errors.add(key.mustNotGreatThen(field.max));
            }
          }
        case SchemaFieldType.bool:
          if (value is! bool) errors.add(key.mustBoolean);
        case SchemaFieldType.list:
          if (value is! List) errors.add(key.mustArray);
        case SchemaFieldType.map:
          if (value is! Map) errors.add(key.mustObject);
      }
    }

    if (errors.isEmpty) return const SchemaResult._valid();
    return SchemaResult._invalid(errors);
  }
}

/// Schema 字段类型。
enum SchemaFieldType { string, int, double, bool, list, map }

/// Schema 字段定义。
class JsonField {
  final SchemaFieldType type;
  final bool required;
  final String? pattern;
  final num? min;
  final num? max;

  const JsonField({
    required this.type,
    this.required = false,
    this.pattern,
    this.min,
    this.max,
  });

  const JsonField.string({
    this.required = false,
    this.pattern,
    this.min,
    this.max,
  }) : type = SchemaFieldType.string;

  const JsonField.int({this.required = false, this.min, this.max})
    : type = SchemaFieldType.int,
      pattern = null;

  const JsonField.double({this.required = false, this.min, this.max})
    : type = SchemaFieldType.double,
      pattern = null;

  const JsonField.bool({this.required = false})
    : type = SchemaFieldType.bool,
      pattern = null,
      min = null,
      max = null;

  const JsonField.list({this.required = false})
    : type = SchemaFieldType.list,
      pattern = null,
      min = null,
      max = null;

  const JsonField.map({this.required = false})
    : type = SchemaFieldType.map,
      pattern = null,
      min = null,
      max = null;
}

/// Schema 校验结果。
class SchemaResult {
  final List<String> errors;
  const SchemaResult._valid() : errors = const [];
  const SchemaResult._invalid(this.errors);

  bool get isValid => errors.isEmpty;
  bool get isInvalid => errors.isNotEmpty;
}
