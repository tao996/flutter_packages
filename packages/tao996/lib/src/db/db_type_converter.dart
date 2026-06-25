// 封装工具类处理类型转换
import 'dart:convert';

import 'package:tao996/tao996.dart';

/// 使用 xxx extends `DbTypeModel<xxx>`
abstract class DbTypeModel<T> {
  Map<String, dynamic> toJson();

  Map<String, dynamic> toMap();
}

class DbTypeConverter {
  static String mapToJson<T extends DbTypeModel<T>>(Map<String, T>? data) {
    if (data == null || data.isEmpty) {
      return '';
    }
    final Map<String, dynamic> map = data.map((key, value) {
      return MapEntry(key, value.toMap());
    });
    return jsonEncode(map);
  }

  static Map<String, T> mapFromJson<T extends DbTypeModel<T>>(
    String? json, {
    required T Function(Map<String, dynamic>) fromMap,
  }) {
    if (json == null || json.isEmpty) {
      return {};
    }
    final Map<String, dynamic> map = MyCastUtil.tryJsonDecode(json);
    return map.map((key, value) {
      return MapEntry(key, fromMap(value));
    });
  }

  /// 调用 toMap 来生成字符串
  static String listToJson<T extends DbTypeModel<T>>(List<T>? items) {
    if (items == null || items.isEmpty) {
      return '';
    }
    return MyCastUtil.listJsonEncode<T>(items, (e) {
      return e.toMap();
    });
  }

  static List<T> listFromJson<T extends DbTypeModel<T>>(
    String? json, {
    required T Function(Map<String, dynamic>) fromMap,
  }) {
    if (json == null || json.isEmpty) {
      return [];
    }
    return MyCastUtil.listJsonDecodeWith<T>(json, (data) {
      return fromMap(data);
    });
  }

  /// 处理任何继承自 DbTypeModel 的嵌套对象
  ///
  /// ```
  /// @JsonKey(
  ///   fromJson: (v) => DbObjectConverter.fromJson(v, SaveSetting.fromJson),
  ///   toJson: DbObjectConverter.toJson,
  /// )
  /// ```
  static T fromJson<T>(dynamic json, T Function(Map<String, dynamic>) factory) {
    if (json == null) return null as T;
    if (json is String) {
      return factory(jsonDecode(json));
    }
    return factory(json as Map<String, dynamic>);
  }

  static String toJson(dynamic model) {
    if (model == null) return '';
    return jsonEncode(model.toJson());
  }
}
