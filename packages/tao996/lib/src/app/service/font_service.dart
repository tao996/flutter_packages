import 'package:tao996/tao996.dart';

/// 字体服务 — 字体大小管理。
class MyFontService {
  final Rx<double> _fontSize = Rx<double>(14.0);

  MyFontService({double initialSize = 14.0}) {
    _fontSize.value = initialSize;
  }

  /// 获取当前字体大小。
  double get fontSize => _fontSize.value;

  /// 获取响应式字体大小。
  Rx<double> get fontSizeRx => _fontSize;

  /// 设置字体大小。
  void setFontSize(double size) {
    if (size >= 10 && size <= 30) {
      _fontSize.value = size;
    }
  }
}
