import 'package:flutter/material.dart';

/// 颜色工具类 - 提供颜色解析、转换、透明度判断等功能。
///
/// 使用方式:
/// ```dart
/// // 颜色转换
/// final color1 = ColorUtil.hexToColor('#fef7ff', opacity: 0.5);
/// final color2 = ColorUtil.rgbToColor('255, 247, 255', opacity: 0.8);
/// final color3 = ColorUtil.parseToColor('#fef7ff');
///
/// // 透明度判断
/// final isTransparent = ColorUtil.isTransparent(Colors.blue.withOpacity(0.5));
///
/// // 棋盘背景（用于显示透明色）
/// final checkerboard = ColorUtil.buildCheckerboard(squareSize: 8);
///
/// // 从 ColorScheme 获取语义化颜色
/// final success = ColorUtil.success(colorScheme);
/// final error = ColorUtil.error(colorScheme);
/// ```
class MyColorUtil {
  MyColorUtil._();
  // 判断颜色是否完全透明（alpha = 0）。
  static bool isFullyTransparent(Color color) => color.a == 0;

  /// 判断颜色是否有透明度（alpha < 255）。
  static bool isTransparent(Color color) => color.a < 255;

  /// 创建一个 8x8 的棋盘背景 Widget，常用于显示透明颜色。
  static Widget buildCheckerboard({double squareSize = 8}) {
    return CustomPaint(painter: _CheckerboardPainter(squareSize: squareSize));
  }

  /// 代表成功的颜色，通常用于表示成功、完成、通过等操作。
  static Color success(ColorScheme colorScheme) => colorScheme.secondary;

  /// 代表失败的颜色，通常用于表示失败、错误、拒绝等操作。
  static Color error(ColorScheme colorScheme) => colorScheme.error;

  /// 危险颜色（error 的别名）。
  static Color danger(ColorScheme colorScheme) => colorScheme.error;

  /// 高亮或信息提示颜色。
  static Color info(ColorScheme colorScheme) => colorScheme.primary;

  /// 警告颜色。
  static Color warning(ColorScheme colorScheme) => colorScheme.tertiary;

  /// 背景、表面式，常用于 AlertDialog
  static Color surface(ColorScheme colorScheme) => colorScheme.surface;

  /// 文本颜色，带透明度。[opacity] 范围 0.0-1.0。
  static Color textColor(double opacity, ColorScheme colorScheme) =>
      colorScheme.onSurface.withAlpha((255 * opacity).toInt());

  /// 将十六进制颜色字符串转换为 Color。
  ///
  /// 示例:
  /// ```dart
  /// Color c1 = ColorUtil.hexToColor("#fef7ff", opacity: 0.5);
  /// ```
  static Color hexToColor(String hexCode, {double opacity = 1.0}) {
    // 1. 去掉 # 号
    String cleanHex = hexCode.replaceAll('#', '');

    // 2. 将十六进制转为整数
    int val = int.parse(cleanHex, radix: 16);

    // 3. 使用 withAlpha 动态设置透明度
    return Color(val | 0xFF000000).withAlpha((opacity * 255).toInt());
  }

  /// 将 RGB 字符串转换为 Color。
  ///
  /// 示例:
  /// ```dart
  /// Color c2 = ColorUtil.rgbToColor("255, 247, 255", opacity: 0.8);
  /// ```
  static Color rgbToColor(String rgbString, {double opacity = 1.0}) {
    try {
      // 1. 切割并转为整数列表
      List<int> parts = rgbString
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();

      if (parts.length != 3) return Colors.black; // 兜底处理

      // 2. 构造颜色
      return Color.from(
        red: parts[0] / 255,
        green: parts[1] / 255,
        blue: parts[2] / 255,
        alpha: opacity,
      );
    } catch (e) {
      return Colors.black; // 解析失败返回黑色
    }
  }

  /// 自动解析颜色字符串（支持十六进制和 RGB 格式）。
  ///
  /// 示例:
  /// ```dart
  /// final color1 = ColorUtil.parseToColor('#fef7ff');
  /// final color2 = ColorUtil.parseToColor('255, 247, 255');
  /// ```
  static Color parseToColor(String input, {double opacity = 1.0}) {
    try {
      if (input.contains('#')) {
        return hexToColor(input, opacity: opacity);
      } else if (input.contains(',')) {
        return rgbToColor(input, opacity: opacity);
      }
    } catch (e) {
      debugPrint("解析颜色失败: $e");
    }
    return Colors.transparent;
  }

  /// 将透明度 (0.0-1.0) 转换为 alpha 值 (0-255)。
  static int withOpacity(double? opacity) {
    return ((opacity ?? 1.0) * 255).toInt();
  }
}

/// 棋盘背景绘制器（内部使用）。
class _CheckerboardPainter extends CustomPainter {
  final double squareSize;
  _CheckerboardPainter({this.squareSize = 8.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = Colors.white;
    final paint2 = Paint()..color = const Color(0xFFE0E0E0); // 浅灰色

    for (double x = 0; x < size.width; x += squareSize) {
      for (double y = 0; y < size.height; y += squareSize) {
        // 交替绘制颜色
        final paint =
            ((x / squareSize).floor() + (y / squareSize).floor()) % 2 == 0
            ? paint1
            : paint2;
        canvas.drawRect(Rect.fromLTWH(x, y, squareSize, squareSize), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
