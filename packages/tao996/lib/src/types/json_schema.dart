import 'package:tao996/tao996.dart';

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
class MyJsonSchema {
  final Map<String, JsonField> fields;

  const MyJsonSchema(this.fields);

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
