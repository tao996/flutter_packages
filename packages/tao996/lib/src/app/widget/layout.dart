import 'package:flutter/material.dart';

/// 布局工具 — 常见的 SizedBox / Column / Row 快捷方法。
class MyLayout {
  MyLayout._();

  static const Widget height8 = SizedBox(height: 8);
  static const Widget height = SizedBox(height: 16);
  static const Widget height24 = SizedBox(height: 24);
  static const Widget width8 = SizedBox(width: 8);
  static const Widget width = SizedBox(width: 16);
  static const Widget emptyWidget = SizedBox.shrink();

  /// 迷你列 — 主轴占用最小空间的 Column。
  static Widget miniColumn(
    List<Widget> children, {
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    double spacing = 0,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: spacing > 0
          ? [
              for (int i = 0; i < children.length; i++) ...<Widget>[
                if (i > 0) SizedBox(height: spacing),
                children[i],
              ],
            ]
          : children,
    );
  }

  /// 迷你行 — 主轴占用最小空间的 Row。
  static Widget miniRow(
    List<Widget> children, {
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    double spacing = 0,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: spacing > 0
          ? [
              for (int i = 0; i < children.length; i++) ...<Widget>[
                if (i > 0) SizedBox(width: spacing),
                children[i],
              ],
            ]
          : children,
    );
  }
}
