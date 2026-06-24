import 'package:tao996/tao996.dart';

/// 语言服务 — 语言切换、当前语言获取。
class LocaleService {
  final TranslationManager _tm;

  LocaleService({required TranslationManager tm}) : _tm = tm;

  /// 获取当前语言代码。
  String getCurrentLocale() => _tm.currentLocale;

  /// 设置语言。
  void setLocale(String locale) => _tm.setLocale(locale);

  /// 获取支持的语言列表。
  List<String> getSupportedLocales() => _tm.supportedLocales;
}
