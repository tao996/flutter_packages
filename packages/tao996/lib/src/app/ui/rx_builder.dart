import 'package:flutter/widgets.dart';
import 'package:tao996/tao996.dart';

/// 响应式 UI 构建器 — 监听单个 [Rx<T>]，值变化时自动重建 Widget。
class RxBuilder<T> extends StatefulWidget {
  final Rx<T> rx;
  final Widget Function(BuildContext context, T value) builder;

  const RxBuilder({super.key, required this.rx, required this.builder});

  @override
  State<RxBuilder<T>> createState() => _RxBuilderState<T>();
}

class _RxBuilderState<T> extends State<RxBuilder<T>> {
  late T _value;
  EventSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _value = widget.rx.value;
    _subscription = widget.rx.listen((newValue) {
      if (mounted) setState(() => _value = newValue);
    });
  }

  @override
  void didUpdateWidget(RxBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rx != widget.rx) {
      _subscription?.cancel();
      _value = widget.rx.value;
      _subscription = widget.rx.listen((newValue) {
        if (mounted) setState(() => _value = newValue);
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _value);
}

/// 监听 [RxBool] 的便捷构建器。
class RxBoolBuilder extends RxBuilder<bool> {
  const RxBoolBuilder({super.key, required RxBool rx, required super.builder})
    : super(rx: rx);
}

/// 监听多个响应式值，任一变化时重建 Widget。
/// 使用 [addDependency] 注册依赖。
class RxListenersBuilder extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final List<EventSubscription Function(void Function())> listeners;

  RxListenersBuilder({
    super.key,
    required this.builder,
    List<EventSubscription Function(void Function())>? listeners,
  }) : listeners = listeners ?? [];

  /// 添加 Rx 依赖。
  void add<T>(Rx<T> rx) {
    listeners.add((fn) => rx.listen((_) => fn()));
  }

  @override
  State<RxListenersBuilder> createState() => _RxListenersBuilderState();
}

class _RxListenersBuilderState extends State<RxListenersBuilder> {
  final _subscriptions = <EventSubscription>[];

  @override
  void initState() {
    super.initState();
    for (final listen in widget.listeners) {
      _subscriptions.add(
        listen(() {
          if (mounted) setState(() {});
        }),
      );
    }
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}
