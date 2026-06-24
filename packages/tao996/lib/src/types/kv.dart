/// Key-Value pair - 用于表单选项、下拉列表等场景。
class KV<T> {
  String label;
  T value;

  KV({required this.label, required this.value});

  @override
  String toString() {
    return 'KV{label: $label, value: $value}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KV &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          value == other.value;

  @override
  int get hashCode => label.hashCode ^ value.hashCode;
}

/// 从枚举映射创建 KV 列表。
List<KV<T>> kvCreateList<T extends Enum>(Map<T, String> maps) {
  final List<KV<T>> list = [];
  maps.forEach((key, label) {
    list.add(KV(label: label, value: key));
  });
  return list;
}

extension KVList<T extends Enum> on List<KV<T>> {
  T? getValue(String? name) {
    return kvTryGetValue(this, name);
  }

  List<String> labels() {
    return map((kv) => kv.label).toList();
  }

  List<T> values() {
    return map((kv) => kv.value).toList();
  }
}

/// 查询列表中指定值的键。
///
/// [kvs] 键值对列表
/// [name] 枚举属性的字符串
/// [firstIfNotFound] 如果找不到，是否返回第一个键
T kvGetValue<T extends Enum>(
  final List<KV<T>> kvs,
  String? name, {
  bool firstIfNotFound = true,
}) {
  for (var kv in kvs) {
    if (kv.value.name == name) {
      return kv.value;
    }
  }
  if (firstIfNotFound) {
    return kvs.first.value;
  }
  throw Exception('Could not find value $name in kvs');
}

/// 尝试查询列表中指定值的键，找不到返回 null。
T? kvTryGetValue<T extends Enum>(final List<KV<T>> kvs, String? name) {
  if (name == null || name.isEmpty) {
    return null;
  }
  for (var kv in kvs) {
    if (kv.value.name == name) {
      return kv.value;
    }
  }
  return null;
}

/// 获取枚举值对应的标签。
String kvGetLabel<T extends Enum>(
  List<KV<T>> kvs,
  T value, {
  String defaultLabel = '',
}) {
  for (var kv in kvs) {
    if (kv.value == value) {
      return kv.label;
    }
  }
  return defaultLabel;
}
