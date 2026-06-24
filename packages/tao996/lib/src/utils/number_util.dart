import 'dart:math';

import 'package:tao996/tao996.dart';

/// 数字处理工具。
class NumberUtil {
  const NumberUtil();

  /// 将分（整数）转换为元（字符串）。
  /// `10001` → `"100.01"`。`fractionDigits=0` 则返回整数。
  String fenToYuan(
    dynamic num, {
    int fractionDigits = 2,
    bool emptyText = true,
  }) {
    final value = _toNum(num);
    if (value == 0) return emptyText ? '' : '0';

    final yuan = value / 100;
    final formatted = yuan.toStringAsFixed(fractionDigits);

    // 去掉多余的末尾零
    if (formatted.contains('.')) {
      return formatted.replaceAll(RegExp(r'\.?0+$'), '');
    }
    return formatted;
  }

  /// 将元（字符串）转换为分（int）。
  /// `"100.01"` → `10001`。
  int yuanToFen(String? money) {
    if (money == null || money.trim().isEmpty) return 0;
    final cleaned = money.replaceAll(RegExp(r'[^\d\.\-]'), '');
    final value = double.tryParse(cleaned);
    if (value == null) return 0;
    return (value * 100).round();
  }

  /// 安全解析 int。
  int parseInt(String? value, {int defaultValue = 0}) {
    if (value == null || value.trim().isEmpty) return defaultValue;
    return int.tryParse(value.trim()) ?? defaultValue;
  }

  /// 安全解析 double。
  double parseDouble(String? value, {double defaultValue = 0.0}) {
    if (value == null || value.trim().isEmpty) return defaultValue;
    return double.tryParse(value.trim()) ?? defaultValue;
  }

  /// 格式化数字为千分位分隔字符串，如 `1234567` → `"1,234,567"`。
  String formatNumber(dynamic value) {
    final num = _toNum(value);
    if (num == 0) return '0';

    final parts = num.toString().split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? '.${parts[1]}' : '';

    // 从右到左每三位加逗号
    final buffer = StringBuffer();
    var count = 0;
    for (var i = intPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
      count++;
    }

    return buffer.toString().split('').reversed.join() + decPart;
  }

  /// 数字列表求和。
  num sum(List<num> list) => list.fold<num>(0, (a, b) => a + b);

  num _toNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    if (v is String) return double.tryParse(v.trim()) ?? 0;
    return 0;
  }

  int numCompare(dynamic a, dynamic b) {
    if (a == null || b == null) {
      return -1;
    }
    try {
      if (a is num) {
        if (b is num) {
          return a.compareTo(b);
        } else if (b is String) {
          return a.compareTo(int.parse(b));
        }
      }
      if (a is String) {
        if (b is num) {
          return int.parse(a).compareTo(b);
        } else if (b is String) {
          return int.parse(a).compareTo(int.parse(b));
        }
      }
    } catch (e, st) {
      dexception(e, st, errorMessage: 'numCompare failed: $a, $b');
    }
    return -1;
  }

  // 从数组中随机选出一个
  T getRandomElement<T>(List<T> list) {
    final random = Random();
    // nextInt 生成一个从 0 到 list.length - 1 的随机整数
    return list[random.nextInt(list.length)];
  }

  // 从 (min,max) 中随机选出一个
  int getRandomInt(int min, int max) {
    final random = Random();
    return random.nextInt(max - min) + min;
  }

  // 从 (0, num) 随机数
  int nextInt(int num) {
    final random = Random();
    return random.nextInt(num);
  }

  // 随机布尔值
  bool getRandomBool() {
    final random = Random();
    return random.nextBool();
  }

  List<int> getInts(String value) {
    return value
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .map((e) => tu.data.getInt(e))
        .where((e) => e > 0)
        .toList();
  }

  /// 从列表中随机挑选指定数量的元素
  /// [items] 源列表
  ///
  /// [length] 要挑选的个数，[minLength] 最少个数，[maxLength] 最多个数; [minLength] , [maxLength] 只有在 [length] == 0 时才有效
  ///
  /// [unique] 是否不重复（默认true）
  List<int> randomPick(
    List<int> items, {
    bool unique = true,
    int minLength = 0,
    int maxLength = 0,
    int length = 0,
  }) {
    // 边界处理：空列表直接返回空
    if (items.isEmpty) return [];
    if (length == 0) {
      if (minLength > 0) {
        if (maxLength > 0) {
          length = getRandomInt(minLength, maxLength);
        } else {
          length = getRandomInt(minLength, items.length);
        }
      } else if (maxLength > 0) {
        length = getRandomInt(0, maxLength);
      }
    }

    // 边界处理：要取的数量不能小于0
    if (length <= 0) return [];

    final random = Random();
    final List<int> result = [];

    if (unique) {
      // 不重复抽取
      // 防止要取的数量 > 列表长度，避免死循环
      final maxPick = items.length;
      final pickCount = length > maxPick ? maxPick : length;

      // 复制一份用于删除已选元素
      final tempList = List<int>.from(items);

      for (int i = 0; i < pickCount; i++) {
        final index = random.nextInt(tempList.length);
        result.add(tempList.removeAt(index));
      }
    } else {
      // 可重复抽取
      for (int i = 0; i < length; i++) {
        final index = random.nextInt(items.length);
        result.add(items[index]);
      }
    }

    return result;
  }
}
