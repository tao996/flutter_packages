/**
 * 事件总线 — EventBus
 *
 * 轻量 pub/sub，纯 Dart / ArkTS / Kotlin / Swift 通用。
 *
 * 生成目标:
 *   Dart → class EventBus, class EventSubscription
 *   ArkTS → class EventBus, class EventSubscription
 *   Kotlin → class EventBus, class EventSubscription
 *   Swift → class EventBus, class EventSubscription
 */

/**
 * 事件总线。
 *
 * ```typescript
 * const bus = new EventBus();
 * const sub = bus.on<string>((msg) => console.log(msg));
 * bus.emit('hello');
 * sub.cancel();
 * ```
 */
declare class EventBus {
  /** 监听指定类型的事件，返回订阅句柄 */
  on<T>(callback: (event: T) => void): EventSubscription;

  /** 发送事件 */
  emit(event: unknown): void;

  /** 取消所有订阅 */
  dispose(): void;
}

/**
 * EventSubscription 定义见 reactive.d.ts。
 * 事件总线复用同一订阅句柄类型，确保一致性。
 */
