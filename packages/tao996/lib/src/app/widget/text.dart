import 'package:flutter/material.dart';

/// 文本样式工具 — 预定义的文字组件，替代手动组合 TextStyle。
class MyText {
  MyText._();

  /// H1 — 超大标题（DisplayMedium）。
  static Widget h1(String text, {Color? color}) =>
      _text(text, MyTextStyles.displayMedium, color, FontWeight.bold);

  /// H2 — 页面主标题（HeadlineSmall）。
  static Widget h2(String text, {Color? color}) =>
      _text(text, MyTextStyles.headlineSmall, color, FontWeight.bold);

  /// H3 — 大卡片标题（TitleLarge）。
  static Widget h3(String text, {Color? color}) =>
      _text(text, MyTextStyles.titleLarge, color, FontWeight.w600);

  /// H4 — 标准列表/分组标题（TitleMedium）。
  static Widget h4(String text, {Color? color}) =>
      _text(text, MyTextStyles.titleMedium, color, FontWeight.w600);

  /// H5 — 正文强调（BodyLarge）。
  static Widget h5(String text, {Color? color}) =>
      _text(text, MyTextStyles.bodyLarge, color, null);

  /// H6 — 默认正文（BodyMedium）。
  static Widget h6(String text, {Color? color}) =>
      _text(text, MyTextStyles.bodyMedium, color, null);

  /// 灰色说明文字。
  static Widget placeholder(String text, {Color? color}) =>
      Text(text, style: TextStyle(color: color, fontSize: 13));

  /// 加粗文字。
  static Widget bold(String text) =>
      Text(text, style: const TextStyle(fontWeight: FontWeight.bold));

  /// 带下划线的可点击文字。
  static Widget inkTitle(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: const TextStyle(
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 分组标题（可带图标+副标题+尾部件）。
  static Widget sectionTitle(
    String title, {
    IconData? iconData,
    String? subTitle,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconData != null) ...[
            Icon(iconData, size: 24),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (subTitle != null && subTitle.isNotEmpty)
                  Text(
                    subTitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  static Widget _text(
    String text,
    TextStyle? style,
    Color? color,
    FontWeight? fontWeight,
  ) {
    return Text(
      text,
      style: style?.copyWith(color: color, fontWeight: fontWeight),
    );
  }
}

/// 文本样式常量（避免每次调用 Theme.of）。
class MyTextStyles {
  MyTextStyles._();

  static const displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );
  static const headlineSmall = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
  static const titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static const titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const bodyLarge = TextStyle(fontSize: 16);
  static const bodyMedium = TextStyle(fontSize: 14);
  static const bodySmall = TextStyle(fontSize: 12, color: Colors.grey);
}
