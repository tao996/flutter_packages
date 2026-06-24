/// 翻译管理器 — 多语言 key-value 查找 + 参数替换。
///
/// 纯 Dart 实现，不依赖 Flutter 的 BuildContext。
///
/// 主 API 使用方式:
/// ```dart
/// // 基本用法
/// i18n('hello', '你好')
/// i18n('yourAgeIs', '你的年龄是@age', params: {'age': 15})
/// i18n('title', '书籍', namespace: 'book')
/// ```
class TranslationManager {
  static final TranslationManager instance = TranslationManager._();

  TranslationManager._();

  final Map<String, Map<String, String>> _keys = {};
  String _locale = 'zh_CN';

  /// 当前语言代码，如 `'zh_CN'`, `'en_US'`。
  String get currentLocale => _locale;

  /// 支持的语言列表。
  List<String> get supportedLocales => _keys.keys.toList();

  /// 设置当前语言。
  void setLocale(String locale) {
    if (_keys.containsKey(locale)) {
      _locale = locale;
    }
  }

  /// 添加翻译字典。
  /// `keys` 格式: `{'zh_CN': {'hello': '你好'}, 'en_US': {'hello': 'Hello'}}`
  void addDict(Map<String, Map<String, String>> keys) {
    for (final entry in keys.entries) {
      _keys.putIfAbsent(entry.key, () => {});
      _keys[entry.key]!.addAll(entry.value);
    }
  }

  /// 添加单语言的翻译。
  void addKeys(Map<String, String> keys, {String? locale}) {
    final loc = locale ?? _locale;
    _keys.putIfAbsent(loc, () => {});
    _keys[loc]!.addAll(keys);
  }

  /// 翻译 key。如果找不到，返回 key 本身。
  /// `params` 用于替换 `{param}` 占位符。
  String translate(String key, {Map<String, String>? params}) {
    var text = _keys[_locale]?[key] ?? key;
    if (params != null && params.isNotEmpty) {
      for (final entry in params.entries) {
        text = text.replaceAll('{${entry.key}}', entry.value);
      }
    }
    return text;
  }

  /// i18n — 带默认中文文案的翻译函数（推荐主 API）。
  ///
  /// [key] 翻译键，如 `'hello'`、`'book.title'`。
  /// [zh] 默认中文文案，查不到翻译时回退此值。
  /// [params] 参数替换，如 `{'age': 15}`。占位符支持 `@age`、`{age}`、`{{age}}` 三种格式。
  /// [namespace] 命名空间，非空时优先查 `namespace.key`。
  ///
  /// ```dart
  /// i18n('hello', '你好')
  /// i18n('yourAgeIs', '你的年龄是@age', params: {'age': 15})
  /// i18n('title', '书籍', namespace: 'book')
  /// ```
  String i18n(
    String key,
    String zh, {
    Map<String, Object?>? params,
    String? namespace,
  }) {
    // 1. 优先查找带 namespace 的 key
    final nsKey = namespace != null ? '$namespace.$key' : null;
    String? text;
    if (nsKey != null) {
      text = _keys[_locale]?[nsKey];
    }

    // 2. 再查裸 key
    text ??= _keys[_locale]?[key];

    // 3. 回退默认中文
    text ??= zh;

    // 4. 参数替换
    if (params != null && params.isNotEmpty) {
      text = _replaceParams(text, params);
    }

    return text;
  }

  /// 重置所有字典（用于测试）。
  void reset() {
    _keys.clear();
    _locale = 'zh_CN';
  }

  /// 替换占位符，支持 @name、{name}、{{name}} 三种格式。
  String _replaceParams(String text, Map<String, Object?> params) {
    var result = text;
    for (final entry in params.entries) {
      final value = entry.value?.toString() ?? '';
      result = result.replaceAll('@${entry.key}', value);
      result = result.replaceAll('{{${entry.key}}}', value);
      result = result.replaceAll('{${entry.key}}', value);
    }
    return result;
  }
}

/// 全局 i18n 函数 — 最便捷的翻译 API。
///
/// ```dart
/// Text(i18n('hello', '你好'))
/// Text(i18n('yourAgeIs', '你的年龄是@age', params: {'age': 15}))
/// ```
String i18n(
  String key,
  String zh, {
  Map<String, Object?>? params,
  String? namespace,
}) {
  return TranslationManager.instance.i18n(key, zh, params: params, namespace: namespace);
}

/// `.tr` 扩展 — 兼容旧代码。
extension StringTranslateExt on String {
  /// 翻译当前字符串。
  String get tr => TranslationManager.instance.translate(this);

  /// 翻译并替换参数。
  String trParams(Map<String, String> params) =>
      TranslationManager.instance.translate(this, params: params);
}
