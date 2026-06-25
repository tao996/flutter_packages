import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  /// 获取当前主题。
  ThemeData get themeData => Theme.of(this);

  /// 获取颜色方案。
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// 获取文本主题。
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// 获取媒体查询。
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get screenWidth => MediaQuery.of(this).size.width;

  /// 是否深色模式。
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
