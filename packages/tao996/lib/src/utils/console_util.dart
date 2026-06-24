import 'dart:math';

import 'package:flutter/foundation.dart';

class MyConsole {
  static const String reset = '\x1B[0m'; // 重置/默认
  static const String black = '\x1B[30m';
  static const String red = '\x1B[31m'; // 红色
  static const String green = '\x1B[32m'; // 绿色
  static const String yellow = '\x1B[33m'; // 黄色
  static const String blue = '\x1B[34m'; // 蓝色
  static const String magenta = '\x1B[35m'; // 紫色/品红
  static const String cyan = '\x1B[36m'; // 青色
  static const String white = '\x1B[37m';

  // 背景色
  static const String bgBlack = '\x1B[40m';
  static const String bgRed = '\x1B[41m';
  static const String bgGreen = '\x1B[42m';
  static const String bgYellow = '\x1B[43m';
  static const String bgBlue = '\x1B[44m';
  static const String bgMagenta = '\x1B[45m';
  static const String bgCyan = '\x1B[46m';
  static const String bgWhite = '\x1B[47m';

  // 样式
  static const String bold = '\x1B[1m'; // 粗体/高亮
  static const String faint = '\x1B[2m';
  static const String italic = '\x1B[3m'; // 斜体
  static const String underline = '\x1B[4m'; // 下划线

  const MyConsole();

  static List<String> colors = [red, green, yellow, blue, magenta, cyan];

  String random() {
    return colors[Random().nextInt(6)];
  }

  String success(String content) {
    return '${MyConsole.green}$content${MyConsole.reset}';
  }

  String error(String content) {
    return '${MyConsole.red}$content${MyConsole.reset}';
  }

  /// 封装成一个函数方便使用
  /// [data] 待打印的数据; [color] 颜色，不提供则为随机色
  void print(
    Object? data, {
    String? color,
    String? bgColor,
    bool bold = false,
  }) {
    if (data == null) {
      return;
    }
    String prefix = color ?? random();
    if (bgColor != null) {
      prefix += bgColor;
    }
    if (bold) {
      prefix += MyConsole.bold;
    }
    debugPrint('$prefix${data.toString()}${MyConsole.reset}');
  }
}
