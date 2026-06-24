/// 便捷聚合器 — 所有工具类的统一入口。
///
/// ```dart
/// tu.data.getInt('42');      // DataUtil
/// tu.date.format(now, 'yyyy-MM-dd');  // DatetimeUtil
/// tu.text.capitalize('hello');  // TextUtil
/// tu.fn.debounce(...);       // FnUtil
/// ```
library;

import '../tao996.dart';

/// 顶级便捷常量 — 所有工具类的聚合入口。
/// 实际不推荐这种写法，因为没办法被 Tree Shaking 优化
const tu = _TUtils();

class _TUtils {
  const _TUtils();

  final array = const ArrayUtil();
  final cast = const CastUtil();
  final crypto = const CryptoUtil();
  final data = const DataUtil();
  final date = const DatetimeUtil();
  final filepath = const FilepathUtil();
  final fn = const FnUtil();
  final json = const JsonUtil();
  final number = const NumberUtil();
  final text = const TextUtil();

  final stack = const StackUtil();
  final console = const MyConsole();
  final color = const ColorUtil();

  /// 创建一个新的验证器
  final validator = Validator.new;

  /// 创建一个新的 jsonString 解析器
  final jsondata = Jsondata.new;

  /// helper
  final contextof = const ContextOfHelper();
  final dialog = const DialogHelper();
  final font = const FontHelper();
  final form = const FormHelper();
  final permission = const PermissionHelper();
  final rxBuilder = const RxBuilderHelper();
  final url = const UrlHelper();
  final widget = const WidgetHelper();
}
