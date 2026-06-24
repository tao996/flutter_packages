import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

/// 函数工具 — debounce、throttle 等。
class FnUtil {
  const FnUtil();

  /// 防抖 — 在 [milliseconds] 内连续调用只执行最后一次。
  /// 返回一个可调用的函数，调用它会重置计时器。
  ///
  /// ```dart
  /// final search = fn.debounce((String q) => api.search(q), milliseconds: 300);
  /// search('a');  // 重置
  /// search('ab'); // 重置
  /// search('abc'); // 300ms 后执行
  /// ```
  DebounceFn debounce(void Function() callback, {int milliseconds = 300}) {
    Timer? timer;
    return DebounceFn(
      () {
        timer?.cancel();
        timer = Timer(Duration(milliseconds: milliseconds), callback);
      },
      () {
        timer?.cancel();
        timer = null;
      },
    );
  }

  /// 节流 — 在 [milliseconds] 内最多执行一次。
  /// 首次调用立即执行，后续调用在冷却期内被忽略。
  void Function() throttle(
    void Function() callback, {
    int milliseconds = 1000,
  }) {
    var lastCallTime = 0;
    return () {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - lastCallTime >= milliseconds) {
        lastCallTime = now;
        callback();
      }
    };
  }

  /// 非阻塞的延时（支持手动取消），返回一个取消函数
  /// ```dart
  /// // 使用方式：
  /// final cancel = startTimeout(Duration(seconds: 5), () => print("Boom!"));
  /// // ... 在 5 秒内如果想后悔：
  /// cancel();
  /// ```
  void Function() startTimeout(Duration duration, void Function() onTimeout) {
    final timer = Timer(duration, onTimeout);

    // 返回一个闭包，用于外部手动取消
    return () {
      if (timer.isActive) {
        timer.cancel();
        debugPrint("计时已手动拦截");
      }
    };
  }

  /// 空闲执行 — 在微任务队列中执行。
  void idle(void Function() callback) {
    Future.microtask(callback);
  }

  /// 延迟执行。
  Future<void> delay(int milliseconds, [void Function()? callback]) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
    callback?.call();
  }

  /// 随机延时 [minMilliseconds] 毫秒 到 [maxMilliseconds] 毫秒的函数。
  ///
  /// 该函数会暂停当前执行，等待一个随机生成的持续时间。
  Future<void> randomDelay({
    int minMilliseconds = 500,
    int maxMilliseconds = 2000,
  }) async {
    final Random random = Random();

    final int randomMilliseconds = random.nextInt(
      maxMilliseconds - minMilliseconds + 1,
    );
    final int delayMilliseconds = minMilliseconds + randomMilliseconds;

    // 使用 Future.delayed 进行延时
    await Future.delayed(Duration(milliseconds: delayMilliseconds));
  }

  /// 恒等函数。
  T identity<T>(T value) => value;

  /// 函数组合 — 从右到左。
  /// ```dart
  /// final f = fn.compose((int x) => x + 1, (int x) => x * 2);
  /// f(5); // 5 * 2 + 1 = 11
  /// ```
  T Function(T) compose<T>(T Function(T) f, T Function(T) g) {
    return (T x) => f(g(x));
  }
}

/// 防抖函数句柄 — 可调用也可取消。
class DebounceFn {
  final void Function() _call;
  final void Function() _cancel;

  DebounceFn(this._call, this._cancel);

  /// 执行（重置计时器）。
  void call() => _call();

  /// 取消待执行的调用。
  void cancel() => _cancel();
}
