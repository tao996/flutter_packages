import 'package:shared_preferences/shared_preferences.dart';

class MySettingHelper {
  final SharedPreferences prefs;
  MySettingHelper(this.prefs);

  // ── 主题 / 字体 ─────────────────────────────────────────────

  /// 0 = system, 1 = light, 2 = dark
  int get themeMode => prefs.getInt('themeMode') ?? 0;
  set themeMode(int value) => prefs.setInt('themeMode', value);

  double get textScaleFactor => prefs.getDouble('textScaleFactor') ?? 1.0;
  set textScaleFactor(double value) =>
      prefs.setDouble('textScaleFactor', value);

  // ── 语言 ────────────────────────────────────────────────────

  /// 'system' | 'zh_CN' | 'en_US'
  String get language => prefs.getString('language') ?? 'system';
  set language(String value) => prefs.setString('language', value);
}
