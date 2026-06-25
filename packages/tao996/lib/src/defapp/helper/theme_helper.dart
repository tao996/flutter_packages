import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tao996/defapp.dart';
import 'package:tao996/tao996.dart';

class MyThemeHelper {
  final MySettingHelper settingHelper;
  late final Rx<ThemeMode> themeModeRx;

  MyThemeHelper(this.settingHelper) {
    themeModeRx = Rx(_modeFromInt(settingHelper.themeMode));
  }

  ThemeMode get themeMode => themeModeRx.value;

  void setThemeMode(ThemeMode mode) {
    settingHelper.themeMode = _intFromMode(mode);
    themeModeRx.value = mode;
  }

  /// 构建浅色主题，优先使用 DynamicColor。
  ThemeData buildLightTheme(ColorScheme? dynamicLight) {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme:
          dynamicLight ??
          ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
    );
  }

  /// 构建深色主题，优先使用 DynamicColor。
  ThemeData buildDarkTheme(ColorScheme? dynamicDark) {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme:
          dynamicDark ??
          ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
    );
  }

  /// 初始化系统 UI 样式（边到边显示）。
  void defaultSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  ThemeMode _modeFromInt(int v) => switch (v) {
    1 => ThemeMode.light,
    2 => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  int _intFromMode(ThemeMode m) => switch (m) {
    ThemeMode.light => 1,
    ThemeMode.dark => 2,
    _ => 0,
  };
}
