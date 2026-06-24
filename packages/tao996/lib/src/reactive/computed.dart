import 'rx.dart';

/// 衍生响应式值 — 根据其他 Rx 自动计算并缓存。
///
/// ```dart
/// final a = Rx(10);
/// final doubled = a.map((v) => v * 2);
/// print(doubled.value); // 20
///
/// a.value = 5;
/// print(doubled.value); // 10（自动重算）
/// ```
class Computed<T> implements ReadonlyRx<T> {
  final T Function() _compute;
  final _listeners = <void Function(T)>[];
  late T _cached;
  bool _dirty = true;
  bool _disposed = false;
  final List<void Function()> _cancelFns = [];

  /// [compute] 计算函数。
  /// 通过 [RxExtensions.map] 或手动 [markDirty] 触发重算。
  Computed(this._compute) : _cached = _compute();

  @override
  T get value {
    if (_dirty && !_disposed) {
      _cached = _compute();
      _dirty = false;
    }
    return _cached;
  }

  /// 标记为脏，下次读取时重新计算。同时通知监听者。
  void markDirty() {
    if (_disposed) return;
    _dirty = true;
    final newValue = value;
    _notify(newValue);
  }

  @override
  EventSubscription listen(void Function(T) callback) {
    _listeners.add(callback);
    return EventSubscription(() => _listeners.remove(callback));
  }

  @override
  void dispose() {
    _disposed = true;
    for (final cancel in _cancelFns) {
      cancel();
    }
    _cancelFns.clear();
    _listeners.clear();
  }

  void _notify(T value) {
    for (final cb in List<void Function(T)>.of(_listeners)) {
      cb(value);
    }
  }
}

/// 只读响应式值接口 — Rx 和 Computed 的共同父类型。
abstract class ReadonlyRx<T> {
  T get value;
  EventSubscription listen(void Function(T) callback);
  void dispose();
}

/// 扩展方法 — 让 Rx 支持派生计算。
extension RxExtensions<T> on Rx<T> {
  /// 从当前 Rx 衍生一个计算值。
  /// 当前 Rx 变化时自动触发计算。
  Computed<R> map<R>(R Function(T value) transform) {
    final computed = Computed<R>(() => transform(value));
    listen((_) => computed.markDirty());
    return computed;
  }
}
