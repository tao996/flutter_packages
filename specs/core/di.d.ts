/**
 * ServiceLocator — 轻量依赖注入容器
 *
 * 所有服务通过此容器注册和获取。
 * 容器只在组装阶段（main()）使用，业务代码通过构造函数接收依赖。
 *
 * 生成目标:
 *   Dart → class ServiceLocator
 *   ArkTS → class ServiceLocator
 *   Kotlin → class ServiceLocator
 *   Swift → class ServiceLocator
 */

/**
 * 服务注册方式
 *
 * - singleton: 全局唯一实例，注册时立即创建
 * - lazySingleton: 全局唯一实例，首次 get() 时创建
 * - factory: 每次 get() 都创建新实例
 */
type ServiceRegistration = 'singleton' | 'lazySingleton' | 'factory';

declare class ServiceLocator {
  /** 注册一个单例实例 */
  registerSingleton<T>(instance: T): void;

  /** 懒注册 — 首次 get() 时才创建实例 */
  registerLazySingleton<T>(factory: () => T): void;

  /** 每次 get() 都创建新实例 */
  registerFactory<T>(factory: () => T): void;

  /** 获取已注册的服务，未注册则抛出 StateError */
  get<T>(): T;

  /** 检查是否已注册 */
  isRegistered<T>(): boolean;

  /**
   * 取消注册指定服务。
   * 如果服务未注册，静默忽略。
   */
  unregister<T>(): void;

  /** 重置所有注册（主要用于测试间隔离） */
  reset(): void;
}
