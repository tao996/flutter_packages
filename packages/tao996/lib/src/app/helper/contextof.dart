import 'package:flutter/material.dart';

/// 主题适配器 — 替代 Get.theme / Get.textTheme 等。
///
/// 提供从 [BuildContext] 获取主题信息的静态方法。
class ContextOfHelper {
  const ContextOfHelper();

  /// 获取当前主题。
  ThemeData theme(BuildContext context) => Theme.of(context);

  /// 获取颜色方案。
  ColorScheme colorScheme(BuildContext context) =>
      Theme.of(context).colorScheme;

  /// 获取文本主题。
  TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;

  /// 获取媒体查询。
  MediaQueryData mediaQuery(BuildContext context) => MediaQuery.of(context);

  /// 是否深色模式。
  bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}
