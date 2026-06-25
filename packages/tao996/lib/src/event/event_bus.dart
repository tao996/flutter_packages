import '../reactive/rx.dart';

/// 轻量事件总线 — 纯 Dart pub/sub。
///
/// 按事件类型派发，支持取消订阅。
///
/// 使用方式:
/// ```dart
/// final bus = EventBus();
/// final sub = bus.on<String>((msg) => print('got: $msg'));
/// bus.emit('hello world');
/// sub.cancel();
/// ```
class MyEventBus {
  final _listeners = <_EventHandler>[];

  /// 监听指定类型的事件。
  EventSubscription on<T>(void Function(T event) callback) {
    final handler = _EventHandler((e) {
      if (e is T) callback(e as T);
    });
    _listeners.add(handler);
    return EventSubscription(() => _listeners.remove(handler));
  }

  /// 发送事件。
  void emit(Object event) {
    for (final handler in List<_EventHandler>.of(_listeners)) {
      handler.callback(event);
    }
  }

  /// 取消所有订阅。
  void dispose() {
    _listeners.clear();
  }
}

class _EventHandler {
  final void Function(Object) callback;

  _EventHandler(this.callback);
}

// EventSubscription 定义见 reactive/rx.dart，此处复用同一类型。
