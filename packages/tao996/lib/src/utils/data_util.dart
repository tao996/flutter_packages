import 'dart:convert';

import 'package:tao996/src/function.dart';
import 'package:tao996/src/tu.dart';

/// 数据转换工具 — 安全地处理动态类型转换。
class DataUtil {
  const DataUtil();

  /// 将任意值转为 bool。
  /// - `null`, `''`, `false`, `0` → `defaultValue` (默认 false)
  /// - `true`, `1`, 正数 → `true`
  /// - 字符串 "true"/"1"/"yes" → `true`
  bool getBool(dynamic v, {bool defaultValue = false}) {
    if (v == null) return defaultValue;
    if (v is bool) return v;
    if (v is num) return v > 0;
    if (v is String) {
      final lower = v.trim().toLowerCase();
      if (lower == 'true' || lower == '1' || lower == 'yes' || lower == "on") {
        return true;
      }
      if (lower == 'false' ||
          lower == '0' ||
          lower == 'no' ||
          lower == "off" ||
          lower == '') {
        return defaultValue;
      }
    }
    return defaultValue;
  }

  /// 将任意值转为 int。
  int getInt(dynamic v, {int defaultValue = 0}) {
    if (v == null) return defaultValue;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) {
      final trimmed = v.trim();
      if (trimmed.isEmpty) return defaultValue;
      return int.tryParse(trimmed) ?? defaultValue;
    }
    return defaultValue;
  }

  /// 将任意值转为 double。
  double getDouble(dynamic v, {double defaultValue = 0.0}) {
    if (v == null) return defaultValue;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) {
      final trimmed = v.trim();
      if (trimmed.isEmpty) return defaultValue;
      return double.tryParse(trimmed) ?? defaultValue;
    }
    return defaultValue;
  }

  DateTime? getDateTime(dynamic v, {DateTime? defaultValue}) {
    return tu.date.parse(v) ?? defaultValue;
  }

  /// 将任意值转为 String。
  String getString(dynamic v, {String defaultValue = ''}) {
    if (v == null) return defaultValue;
    return v.toString();
  }

  /// 将任意对象转为 JSON 字符串。
  String jsonString(dynamic data) => const JsonEncoder().convert(data);

  /// 深拷贝（通过 JSON 序列化/反序列化）。
  dynamic copy(dynamic data) => jsonDecode(jsonEncode(data));

  /// 校验字符串是否匹配正则。
  bool hasMatch(String data, String pattern) => RegExp(pattern).hasMatch(data);

  List<T>? getList<T>(
    dynamic v,
    T Function(Map<String, dynamic>) fromJson, {
    List<T>? defaultValue,
  }) {
    if (v == null || v == "") {
      return defaultValue;
    }
    try {
      return (v as List<dynamic>)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      dexception(e, stackTrace);
    }
    return defaultValue;
  }

  /// 获取第一个不为 null 的值
  dynamic firstValue(Map<String, dynamic> json, List<String> keys) {
    for (var key in keys) {
      if (json.containsKey(key)) {
        return json[key];
      }
    }
    return null;
  }

  int getIntFromBool(bool value) {
    return value ? 1 : 0;
  }

  bool getBoolFromInt(int value) {
    return value == 1;
  }

  /// 从字符串 [input] 中获取所有匹配项，匹配项的格式为 [pattern]
  List<String> getAllMatches(String pattern, String input) {
    // 使用 allMatches() 来获取所有匹配项的迭代器
    final Iterable<RegExpMatch> matches = RegExp(pattern).allMatches(input);
    final List<String> result = [];
    if (matches.isNotEmpty) {
      for (final match in matches) {
        result.add(match.group(0)!);
      }
    }
    return result;
  }

  /// 从字符串 [input] 中获取第一个匹配项，匹配项的格式为 [pattern]
  String? getFirstMatch(String pattern, String input) {
    final match = RegExp(pattern).firstMatch(input);
    return match?.group(0);
  }

  /// 清除用户输入的正则表达式，返回一个可用户的系统正则表达式；
  String getUserInputRegexPattern(String input) {
    // 1. 移除字符串两端的空白符
    String cleaned = input.trim();
    // 2. 检查是否为原始字符串字面量格式 (r'...' 或 r"...")
    if (cleaned.length >= 3 && cleaned.startsWith('r')) {
      String firstQuote = cleaned[1];
      String lastQuote = cleaned[cleaned.length - 1];
      if (firstQuote == lastQuote && (firstQuote == "'" || firstQuote == '"')) {
        // 如果是，直接剥离 'r' 和引号，返回中间的内容
        // 这里不对内容做任何处理，因为 r'' 的作用就是保留所有字符的字面量
        return cleaned.substring(2, cleaned.length - 1);
      }
    }
    return cleaned;
  }

  /// 获取数据运行时的类型
  Type getType(dynamic data) {
    return data.runtimeType;
  }
}
