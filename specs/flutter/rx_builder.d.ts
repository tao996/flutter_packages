/**
 * RxBuilder — 响应式 UI 构建器
 *
 * 替代 GetX 的 Obx 组件。
 * 监听 Rx<T> 的变化，自动重建 Widget。
 * 依赖 specs/core/reactive 中的 Rx / ReadonlyRx / EventSubscription。
 *
 * 生成目标:
 *   Dart → class RxBuilder<T> extends StatefulWidget
 *   ArkTS → @Builder + @State + @Watch
 *   Kotlin → @Composable + collectAsState()
 *   Swift → View + @ObservedObject
 */

import type { Rx, RxBool, ReadonlyRx, EventSubscription } from "../core/reactive";
import type { BuildContextRef, WidgetRef } from "./common";

/** 单 Rx 构建器选项 */
export interface RxBuilderOptions<T> {
  /** 监听的响应式值 */
  rx: Rx<T>;
  /** 构建 UI */
  builder: (context: BuildContextRef, value: T) => WidgetRef;
}

/** 单 Rx 构建器 */
export declare class RxBuilder<T> {
  constructor(options: RxBuilderOptions<T>);
}

/** RxBool 构建器选项 */
export interface RxBoolBuilderOptions {
  rx: RxBool;
  builder: (context: BuildContextRef, value: boolean) => WidgetRef;
}

/** RxBool 构建器 */
export declare class RxBoolBuilder extends RxBuilder<boolean> {
  constructor(options: RxBoolBuilderOptions);
}

/** 多 Rx 构建器选项 */
export interface RxBuilder2Options {
  /** 监听的 Rx 列表，任一变化时重建 */
  deps: ReadonlyRx<any>[];
  /** 构建 UI */
  builder: (context: BuildContextRef) => WidgetRef;
}

/** 多 Rx 构建器 */
export declare class RxBuilder2 {
  constructor(options: RxBuilder2Options);
}
