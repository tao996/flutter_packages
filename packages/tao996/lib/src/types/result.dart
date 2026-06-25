/// Result — Rust 风格的结果类型，clean error handling。
///
/// 表示一个可能成功或失败的操作结果，无需 try/catch。
///
/// ```dart
/// Result<int, String> divide(int a, int b) {
///   if (b == 0) return Result.err('除数不能为 0');
///   return Result.ok(a ~/ b);
/// }
///
/// final result = divide(10, 2);
/// result.match(
///   ok: (v) => print(v),       // 5
///   err: (e) => print(e),
/// );
/// ```
sealed class MyResult<T, E> {
  const MyResult();

  /// 创建成功结果。
  factory MyResult.ok(T value) => Ok(value);

  /// 创建失败结果。
  factory MyResult.err(E error) => Err(error);

  /// 包装 try/catch — 将可能抛异常的代码转为 Result。
  ///
  /// ```dart
  /// final result = Result.tryCatch<int, String>(
  ///   () => int.parse('42'),
  ///   (e) => '解析失败: $e',
  /// );
  /// ```
  factory MyResult.tryCatch(
    T Function() block,
    E Function(Object error) onError,
  ) {
    try {
      return MyResult.ok(block());
    } catch (e) {
      return MyResult.err(onError(e));
    }
  }

  /// 是否成功。
  bool get isOk => this is Ok<T, E>;

  /// 是否失败。
  bool get isErr => this is Err<T, E>;

  /// 获取成功值，失败时抛出 StateError。
  T get value {
    if (this is Ok<T, E>) return (this as Ok<T, E>).value;
    throw StateError('Called value on Err: ${(this as Err<T, E>).error}');
  }

  /// 获取错误值，成功时抛出 StateError。
  E get error {
    if (this is Err<T, E>) return (this as Err<T, E>).error;
    throw StateError('Called error on Ok');
  }

  /// 模式匹配。
  R match<R>({
    required R Function(T value) ok,
    required R Function(E error) err,
  });

  /// 成功时执行回调。
  MyResult<T, E> onOk(void Function(T value) callback) {
    if (this is Ok<T, E>) callback((this as Ok<T, E>).value);
    return this;
  }

  /// 失败时执行回调。
  MyResult<T, E> onErr(void Function(E error) callback) {
    if (this is Err<T, E>) callback((this as Err<T, E>).error);
    return this;
  }

  /// 映射成功值。
  MyResult<R, E> map<R>(R Function(T value) transform) {
    return match(
      ok: (v) => MyResult.ok(transform(v)),
      err: (e) => MyResult.err(e),
    );
  }

  /// 映射错误值。
  MyResult<T, R> mapErr<R>(R Function(E error) transform) {
    return match(
      ok: (v) => MyResult.ok(v),
      err: (e) => MyResult.err(transform(e)),
    );
  }

  /// 链式调用 — 如果成功则执行 [next]，否则原样传递错误。
  MyResult<R, E> then<R>(MyResult<R, E> Function(T value) next) {
    return match(ok: (v) => next(v), err: (e) => MyResult.err(e));
  }

  /// 获取成功值，失败时返回 [defaultValue]。
  T orDefault(T defaultValue) => isOk ? value : defaultValue;

  /// 获取成功值，失败时执行 [fallback] 获取替代值。
  T orElse(T Function(E error) fallback) => isOk ? value : fallback(error);
}

/// 成功结果。
class Ok<T, E> extends MyResult<T, E> {
  @override
  final T value;
  const Ok(this.value);

  @override
  R match<R>({required R Function(T) ok, required R Function(E) err}) =>
      ok(value);

  @override
  String toString() => 'Ok($value)';
}

/// 失败结果。
class Err<T, E> extends MyResult<T, E> {
  @override
  final E error;
  const Err(this.error);

  @override
  R match<R>({required R Function(T) ok, required R Function(E) err}) =>
      err(error);

  @override
  String toString() => 'Err($error)';
}
