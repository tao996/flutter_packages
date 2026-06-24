/// 响应式值包装 — [Rx<T>], [RxBool], [RxInt], [RxList<T>]。
///
/// 轻量级实现，无外部依赖。UI 层负责将变化映射到视图。
library;

/// 事件订阅句柄 — 用于取消 [Rx.listen] 的订阅。
class EventSubscription {
  final void Function() _cancel;

  EventSubscription(this._cancel);

  /// 取消订阅。
  void cancel() => _cancel();
}

/// 单个值的响应式包装。
///
/// setter 会通知所有已注册的监听者。
class Rx<T> {
  T _value;
  final _listeners = <void Function(T)>[];

  Rx(this._value);

  /// 当前值。setter 会通知所有监听者。
  T get value => _value;
  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    _notifyListeners();
  }

  /// 注册值变化监听。返回 [EventSubscription] 用于取消。
  EventSubscription listen(void Function(T) callback) {
    _listeners.add(callback);
    return EventSubscription(() => _listeners.remove(callback));
  }

  /// 强制通知所有监听者，即使 value 未变化。
  /// 用于 RxList.refresh() 等手动触发 UI 刷新场景。
  void refresh() {
    _notifyListeners();
  }

  /// 取消所有监听，释放资源。
  void dispose() {
    _listeners.clear();
  }

  /// 通知所有监听者（可由子类调用，如 RxList.refresh）。
  void notifyListeners() => _notifyListeners();

  void _notifyListeners() {
    for (final l in List<void Function(T)>.of(_listeners)) {
      l(_value);
    }
  }
}

/// Bool 类型的响应式包装。
class RxBool extends Rx<bool> {
  RxBool([super.initial = false]);

  /// 切换布尔值。
  void toggle() => value = !value;
}

/// Int 类型的响应式包装。
class RxInt extends Rx<int> {
  RxInt([super.initial = 0]);

  /// 自增。
  void increment() => value++;

  /// 自减。
  void decrement() => value--;
}
