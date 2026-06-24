import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:fast_gbk/fast_gbk.dart';

const myRandomChars = 'abcdefghijklmnopqrstuvwxyz0123456789';
final RegExp halfWidthChars = RegExp("[a-zA-Z0-9\\s.,!?:;\"'\\-]");

/// 文本处理工具。
class TextUtil {
  const TextUtil();

  /// Base64 编码。
  String base64Encode(String input) => base64.encode(utf8.encode(input));

  /// Base64 解码。
  String base64Decode(String input) => utf8.decode(base64.decode(input));

  /// 截断字符串到指定长度，超出加 `suffix`（默认 `...`）。
  String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}$suffix';
  }

  /// 首字母大写。
  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// 每个单词首字母大写。
  String capitalizeAll(String text) {
    return text.split(' ').map(capitalize).join(' ');
  }

  /// 转为小写驼峰（camelCase）。
  String toCamelCase(String text) {
    final words = text.split(RegExp(r'[_\-\s]+'));
    if (words.isEmpty) return '';
    final first = words.first.toLowerCase();
    final rest = words.skip(1).map(capitalize).join();
    return '$first$rest';
  }

  /// 转为蛇形命名（snake_case）。
  String toSnakeCase(String text) {
    return text
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (m) => '_${m.group(0)!.toLowerCase()}',
        )
        .replaceAll(RegExp(r'[-\s]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '')
        .toLowerCase();
  }

  /// 转为连字符命名（kebab-case）。
  String toKebabCase(String text) => toSnakeCase(text).replaceAll('_', '-');

  /// 反转字符串。
  String reverse(String text) =>
      String.fromCharCodes(text.runes.toList().reversed);

  /// 是否为空或空白。
  bool isBlank(String? text) => text == null || text.trim().isEmpty;

  /// 是否不为空。
  bool isNotBlank(String? text) => !isBlank(text);

  /// 移除所有空白字符。
  String removeWhitespace(String text) => text.replaceAll(RegExp(r'\s+'), '');

  /// 取前 [count] 个字符。
  String first(String text, int count) =>
      text.length <= count ? text : text.substring(0, count);

  /// 取后 [count] 个字符。
  String last(String text, int count) =>
      text.length <= count ? text : text.substring(text.length - count);

  /// 重复字符串 [count] 次。
  String repeat(String text, int count) => text * count;

  /// 补零到指定位数。
  String padZero(int value, int length) =>
      value.toString().padLeft(length, '0');

  /// 生成随机字符串。
  String random(int length, {String chars = myRandomChars}) {
    final random = math.Random();
    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  String merge(
    String separator,
    String text0, [
    String? text1,
    String? text2,
    String? text3,
    String? text4,
    String? text5,
    String? text6,
    String? text7,
    String? text8,
    String? text9,
    String? text10,
    String? text11,
    String? text12,
    String? text13,
    String? text14,
    String? text15,
  ]) {
    return [
      text0,
      text1,
      text2,
      text3,
      text4,
      text5,
      text6,
      text7,
      text8,
      text9,
      text10,
      text11,
      text12,
      text13,
      text14,
      text15,
    ].where((element) => element != null && element.isNotEmpty).join(separator);
  }

  /// 获取字符串长度（两个半角宽字符算一个长度）
  int textLength(String text) {
    // 1. 获取所有半角字符 (英文字母、数字、空格和标点)
    final Iterable<Match> matches = halfWidthChars.allMatches(text);
    final int halfCharCount = matches.length;

    // 2. 估算半角字符折算成的“汉字宽度”
    // 经验值：2 个半角字符 ~= 1 个全角汉字
    final double estimatedHalfWidth = halfCharCount / 2.0;

    // 3. 计算全角字符 (非半角字符) 的数量
    // 简单地用总长度减去半角字符数
    final int fullCharCount = text.length - halfCharCount;

    // 4. 总估算宽度 (以汉字为基准单位)
    return fullCharCount + estimatedHalfWidth.ceil();
  }

  /// 获取最大宽度
  int maxLength(List<String> texts) {
    int l = 0;
    for (String text in texts) {
      l = math.max(l, textLength(text));
    }
    return l;
  }

  /// 去除右边的 trim
  String trimRight(String text, String trim) {
    if (text.endsWith(trim)) {
      return text.substring(0, text.length - trim.length);
    }
    return text;
  }

  String trimLeft(String text, String trim) {
    if (text.startsWith(trim)) {
      return text.substring(trim.length);
    }
    return text;
  }

  /// 编写通用适配解码器
  /// 优先检查 BOM (字节顺序标记)，其次尝试 UTF-8，最后回退到 GBK。
  String decode(List<int> bytes) {
    if (bytes.isEmpty) return "";

    // 1. 处理 UTF-16 (Windows 常见的 Little Endian)
    // 特征：开头是 [0xFF, 0xFE]
    if (bytes.length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xFE) {
      return String.fromCharCodes(
        Uint16List.view(Uint8List.fromList(bytes).buffer, 2),
      );
    }

    // 2. 尝试 UTF-8 解码
    // 逻辑：如果字节流符合 UTF-8 规范，优先按 UTF-8 处理
    try {
      // allowMalformed: false 会在遇到非 UTF-8 字符时抛出异常
      return const Utf8Decoder(allowMalformed: false).convert(bytes);
    } catch (_) {
      // 3. 回退到 GBK (Windows 中文环境最可能的编码)
      try {
        return gbk.decode(bytes);
      } catch (e) {
        // 4. 最后的防线：Latin1 (至少保证能显示，不崩溃)
        return latin1.decode(bytes);
      }
    }
  }
}
