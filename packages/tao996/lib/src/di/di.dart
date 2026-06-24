/// 轻量依赖注入容器。
///
/// 所有服务通过此容器注册和获取。
/// 容器只在组装阶段（main()）使用，业务代码通过构造函数接收依赖。
class Di {
  final Map<Type, _ServiceFactory<Object>> _factories = {};
  final Map<Type, Object> _singletons = {};
  final Map<Type, Object> _lazyCache = {};

  Di();

  /// 注册一个单例实例。
  void registerSingleton<T extends Object>(T instance) {
    _singletons[T] = instance;
  }

  /// 懒注册 — 首次 [get] 时才创建实例。
  void registerLazySingleton<T extends Object>(T Function() factory) {
    _factories[T] = _ServiceFactory(factory, isLazy: true);
  }

  /// 每次 [get] 都创建新实例。
  void registerFactory<T extends Object>(T Function() factory) {
    _factories[T] = _ServiceFactory(factory, isLazy: false);
  }

  /// 获取已注册的服务，未注册则抛出 [StateError]。
  T get<T extends Object>() {
    if (_singletons.containsKey(T)) {
      return _singletons[T] as T;
    }
    if (_factories.containsKey(T)) {
      final factory = _factories[T]!;
      if (factory.isLazy) {
        if (!_lazyCache.containsKey(T)) {
          _lazyCache[T] = factory.create();
        }
        return _lazyCache[T] as T;
      }
      return factory.create() as T;
    }
    throw StateError('Service $T is not registered');
  }

  /// 检查是否已注册。
  bool isRegistered<T extends Object>() =>
      _singletons.containsKey(T) || _factories.containsKey(T);

  /// 取消注册指定服务。如果服务未注册，静默忽略。
  void unregister<T extends Object>() {
    _singletons.remove(T);
    _factories.remove(T);
    _lazyCache.remove(T);
  }

  /// 重置所有注册（主要用于测试间隔离）。
  void reset() {
    _singletons.clear();
    _factories.clear();
    _lazyCache.clear();
  }
}

class _ServiceFactory<T extends Object> {
  final T Function() _factory;
  final bool isLazy;

  _ServiceFactory(this._factory, {required this.isLazy});

  T create() => _factory();
}
