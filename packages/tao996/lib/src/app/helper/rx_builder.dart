import 'package:flutter/widgets.dart';
import 'package:tao996/tao996.dart';

class RxBuilderHelper {
  const RxBuilderHelper();

  /// 响应式 UI 构建器 — 监听单个 [Rx<T>]，值变化时自动重建 Widget。
  Widget widget<T>({
    required Widget Function(BuildContext context, T value) builder,
    required Rx<T> rx,
    Key? key,
  }) {
    return RxBuilder<T>(
      key: key,
      rx: rx,
      builder: (context, value) => builder(context, value),
    );
  }

  /// 监听 [RxBool] 的便捷构建器。
  Widget boolWidget({
    required Widget Function(BuildContext context, bool value) builder,
    required RxBool rx,
    Key? key,
  }) {
    return RxBoolBuilder(
      key: key,
      rx: rx,
      builder: (context, value) => builder(context, value),
    );
  }

  /// 监听多个响应式值，任一变化时重建 Widget。
  Widget listeners({
    required Widget Function(BuildContext context) builder,
    List<EventSubscription Function(void Function())>? listeners,
    Key? key,
  }) {
    return RxListenersBuilder(key: key, builder: builder, listeners: listeners);
  }
}
