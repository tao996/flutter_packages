/**
 * 路由规范 — Route Registry
 *
 * 替代 GetPage / Get.toNamed / Get.arguments。
 * 所有路由通过 RouteRegistry 注册和解析，参数通过 RouteRequest 传递。
 *
 * 生成目标:
 *   Dart → class RouteRegistry + MaterialPageRoute
 *   ArkTS → class RouteRegistry + NavPathStack
 *   Kotlin → object RouteRegistry + NavController
 *   Swift → class RouteRegistry + NavigationStack
 */

import type { WidgetRef } from "./common";

/** 路由名称 */
export type RouteName = string;

/** 路由参数 */
export type RouteArguments = unknown;

/** 路由请求 */
export interface RouteRequest {
  name: RouteName;
  arguments?: RouteArguments;
}

/** 路由建造器：根据请求返回 UI 组件 */
export type RouteBuilder = (request: RouteRequest) => WidgetRef;

/** 路由注册表 */
export declare class RouteRegistry {
  /** 注册路由 */
  static register(name: RouteName, builder: RouteBuilder): void;

  /** 取消注册 */
  static unregister(name: RouteName): void;

  /** 是否已注册 */
  static contains(name: RouteName): boolean;

  /** 解析路由，返回已注册的建造器 */
  static resolve(request: RouteRequest): WidgetRef | null;

  /** 清除所有路由 */
  static clear(): void;
}

/** 导航适配器 */
export declare class NavigationAdapter {
  /** 推入命名路由 */
  static pushNamed(context: any, name: RouteName, arguments?: RouteArguments): Promise<any>;

  /** 返回上一页 */
  static pop(context: any, result?: any): void;

  /** 替换当前路由 */
  static pushReplacementNamed(context: any, name: RouteName, arguments?: RouteArguments): Promise<any>;
}
