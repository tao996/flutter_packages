/**
 * 响应式基元 — Reactive Primitives
 *
 * 轻量级响应式值包装，纯 Dart / ArkTS / Kotlin / Swift 通用规范。
 * 不依赖任何框架（Flutter/ArkUI/Compose/SwiftUI），UI 层负责将变化映射到视图。
 *
 * 生成目标:
 *   Dart → class Rx<T>, class RxList<T>, class RxBool, class RxInt
 *   ArkTS → class Rx<T>, class RxList<T> (内部对接 @State/@Prop)
 *   Kotlin → class Rx<T> (内部使用 StateFlow/MutableStateFlow)
 *   Swift → class Rx<T> (内部使用 @Published / ObservableObject)
 */

/**
 * Rx<T> — 单个值的响应式包装
 *
 * 用法:
 *   const count = new Rx<number>(0);
 *   count.value = 42;           // 触发监听
 *   console.log(count.value);    // 42
 *
 * 测试:
 *   const values: number[] = [];
 *   count.listen(v => values.push(v));
 *   count.value = 1;
 *   count.value = 2;
 *   assert.deepEqual(values, [1, 2]);
 */
declare class Rx<T> {
  constructor(initialValue: T);

  /** 当前值。setter 会通知所有监听者 */
  get value(): T;
  set value(newValue: T): void;

  /** 注册值变化监听。返回 [EventSubscription] 用于取消 */
  listen(callback: (newValue: T) => void): EventSubscription;

  /**
   * 强制通知所有监听者，即使 value 未变化。
   * 用于 RxList.refresh() 等手动刷新场景。
   */
  refresh(): void;

  /** 取消所有监听，释放资源 */
  dispose(): void;
}

/**
 * RxList<T> — 响应式数组
 *
 * 集合变异操作自动通知。原子替换：整个列表替换为新的数组引用。
 *
 * ```typescript
 * const items = new RxList<string>();
 * items.add('hello');
 * items.addAll(['world', 'foo']);
 * items.removeAt(0);
 * console.log(items.value);   // ['world', 'foo']
 * ```
 */
declare class RxList<T> extends Rx<T[]> {
  constructor(initial?: T[]);

  /** 尾部追加一个元素 */
  add(item: T): void;

  /** 批量追加 */
  addAll(items: T[]): void;

  /** 移除指定索引元素 */
  removeAt(index: number): void;

  /** 在指定位置插入 */
  insert(index: number, item: T): void;

  /** 移除满足条件的元素 */
  removeWhere(predicate: (item: T) => boolean): void;

  /** 更新指定索引的值 */
  set(index: number, item: T): void;

  /** 是否包含指定元素 */
  contains(item: T): boolean;

  /** 查找满足条件的第一个索引 */
  indexWhere(predicate: (item: T) => boolean): number;

  /** 过滤出满足条件的元素 */
  where(predicate: (item: T) => boolean): T[];

  /** 映射转换 */
  map<R>(mapper: (item: T) => R): R[];

  /** 清空列表 */
  clear(): void;

  /** 用新数组替换全部 */
  replaceAll(items: T[]): void;

  /** 强制通知监听者（值不变时手动触发） */
  refresh(): void;

  /** 当前长度 */
  get length(): number;

  /** 按索引访问 */
  get(index: number): T;
}

/**
 * RxBool — Bool 类型的响应式包装
 */
declare class RxBool extends Rx<boolean> {
  constructor(initial?: boolean);

  /** 切换布尔值 */
  toggle(): void;
}

/**
 * RxInt — Integer 类型的响应式包装
 */
declare class RxInt extends Rx<number> {
  constructor(initial?: number);

  /** 自增 */
  increment(): void;

  /** 自减 */
  decrement(): void;
}

// ──────────────────────────────────────────
// Computed — 衍生计算值
// ──────────────────────────────────────────

/**
 * EventSubscription — 事件订阅句柄。
 * 用于取消 [Rx.listen] / [EventBus.on] / [Computed.listen] 的订阅。
 *
 * 生成目标:
 *   Dart → class EventSubscription { void cancel(); }
 *   ArkTS → class EventSubscription { cancel(): void }
 *   Kotlin → class EventSubscription { fun cancel() }
 *   Swift → class EventSubscription { func cancel() }
 */
declare class EventSubscription {
  /** 取消订阅 */
  cancel(): void;
}

/**
 * ReadonlyRx — 只读响应式值接口。
 * Rx 和 Computed 的共同父类型。
 */
declare interface ReadonlyRx<T> {
  get value(): T;
  listen(callback: (newValue: T) => void): EventSubscription;
  dispose(): void;
}

/**
 * Computed — 衍生响应式值，根据其他 Rx 自动计算并缓存。
 *
 * ```typescript
 * const a = new Rx(10);
 * const doubled = a.map(v => v * 2);
 * console.log(doubled.value); // 20
 *
 * a.value = 5;
 * console.log(doubled.value); // 10（自动重算）
 * ```
 */
declare class Computed<T> implements ReadonlyRx<T> {
  constructor(compute: () => T);
  get value(): T;
  /** 手动标记为脏，触发重算 */
  markDirty(): void;
  listen(callback: (newValue: T) => void): EventSubscription;
  dispose(): void;
}
