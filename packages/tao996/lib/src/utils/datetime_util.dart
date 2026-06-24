// 正则表达式：匹配 YYYY-MM-DDTXX:XX:XX.XXX... 的格式
// ^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d+$ 匹配了日期、T、时间、点和至少一位数字
import 'package:tao996/tao996.dart';
import 'package:intl/intl.dart';

final RegExp _iso8601Regex = RegExp(
  r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3,6}$',
);

/// 日期时间工具。
class DatetimeUtil {
  const DatetimeUtil();

  /// 仅使用正则表达式检查字符串是否匹配 toIso8601String() 的格式。
  /// 注意：此方法不验证日期（如 2025-02-30）或时间（如 25:00:00）的有效性。
  bool isIso8601FormatRegex(dynamic input) {
    if (input == null || input is! String) {
      return false;
    }
    return _iso8601Regex.hasMatch(input);
  }

  /// 格式化 DateTime 为字符串。
  /// `pattern` 占位符: `yyyy`=年, `MM`=月, `dd`=日, `HH`=时(24h), `mm`=分, `ss`=秒。
  /// 示例: `format(now, 'yyyy-MM-dd')` → `"2026-06-05"`
  String format(DateTime date, String pattern) {
    return pattern
        .replaceAll('yyyy', _pad(date.year, 4))
        .replaceAll('MM', _pad(date.month, 2))
        .replaceAll('dd', _pad(date.day, 2))
        .replaceAll('HH', _pad(date.hour, 2))
        .replaceAll('mm', _pad(date.minute, 2))
        .replaceAll('ss', _pad(date.second, 2));
  }

  /// 解析 微秒/毫秒/日期/字符串 为 DateTime。
  ///
  /// 支持 ISO-8601 格式 (`2026-06-05T10:30:00`) 和标准日期格式 (`2026-06-05`)。
  /// [formatPattern] 如果是字符串，支持自定义 data 的格式
  DateTime? parse(dynamic data, {String? formatPattern}) {
    if (data == null || data == "") {
      return null;
    }
    if (data is int) {
      return DateTime.fromMicrosecondsSinceEpoch(
        data > 1000000000000 ? data : data * 1000,
      );
    } else if (data is String) {
      try {
        return DateTime.tryParse(data);
      } on FormatException catch (_) {
        if (formatPattern != null) {
          return DateFormat(formatPattern).parse(data);
        }
        /*
EEE: 解析星期几的缩写。
dd: 解析日期，两位数。
MMM: 解析月份的缩写。
yyyy: 解析年份，四位数。
HH: 解析小时，24小时制，两位数。
mm: 解析分钟，两位数。
ss: 解析秒，两位数。
Z: 解析时区偏移。intl 包的 DateFormat 能够识别 RFC 822 格式中的 +HHMM 或 -HHMM 时区偏移。
 */
        const dateFormatPatterns = [
          'EEE, dd MMM yyyy HH:mm:ss Z', // Thu, 22 May 2025 13:04:00 +0800
          'EEE, d MMM yyyy HH:mm:ss Z',
          'EEE, dd MMM yyyy HH:mm:ss',
          'EEE, d MMM yyyy HH:mm:ss',
          'yyyy-MM-dd HH:mm:ss Z',
        ]; // 可能有多种格式
        for (final pattern in dateFormatPatterns) {
          try {
            final format = DateFormat(pattern);
            return format.parse(data);
          } catch (_) {}
        }
      }
      throw i18n('dateParseFailed', '日期解析失败:@reason', params: {'reason': data});
    } else if (data is DateTime) {
      return data;
    } else {
      throw i18n(
        'dateParseInvalid',
        '日期解析失败,不支持的类型:@reason',
        params: {'reason': data.runtimeType.toString()},
      );
    }
  }

  /// 返回今天的日期（不含时间）。
  DateTime today() => DateTime(now().year, now().month, now().day);

  /// 返回当前时间。
  DateTime now() => DateTime.now();

  /// 计算两个日期之间的天数差（取绝对值）。
  int daysBetween(DateTime a, DateTime b) => DateTime(
    a.year,
    a.month,
    a.day,
  ).difference(DateTime(b.year, b.month, b.day)).inDays.abs();

  /// 获取两个时间之间的年份，通常用来计算年龄
  int yearBetween(DateTime? a, DateTime? b) {
    if (a != null) {
      if (b != null) {
        return b.year - a.year;
      } else {
        return DateTime.now().year - a.year;
      }
    }
    return 0;
  }

  String _pad(int value, int length) => value.toString().padLeft(length, '0');
  // 比较方法
  int compareTo(dynamic a, dynamic b) {
    if (a == null || a == '') {
      return -1;
    } else if (b == null || b == '') {
      return 1;
    }
    if (a is String && b is String) {
      final at = parse(a);
      final bt = parse(b);
      if (at == null || bt == null) {
        return 0;
      }
      return at.compareTo(bt);
    }
    if (a is DateTime && b is DateTime) {
      return a.compareTo(b);
    }
    return 0;
  }

  /// 获取时间戳
  /// [l10] 10 位的时间戳，用于 php 之类的；
  /// [l13] 13 位毫秒级时间戳（自 Unix 纪元（1970-01-01 00:00:00 UTC）以来的毫秒数）
  /// 默认为 16 位微秒级时间戳（自 Unix 纪元以来的微秒数，1毫秒=1000微秒）
  int timestamp(DateTime dt, {bool l10 = false, bool l13 = false}) {
    if (l10) {
      return dt.millisecondsSinceEpoch % 1000;
    } else if (l13) {
      return dt.millisecondsSinceEpoch;
    }
    return dt.microsecondsSinceEpoch;
  }

  // 格式化分钟数
  String humanMinutes(int totalMinutes) {
    if (totalMinutes <= 0) return '';
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }
}
