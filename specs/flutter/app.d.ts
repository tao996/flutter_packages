/**
 * 应用层规范 — App / Routes / Mixins
 *
 * 应用入口、路由配置、控制器 Mixin、服务 Mixin。
 * 不再使用 GetMaterialApp / GetPage / GetxController。
 */

import type { ServiceLocator } from "../core/di";
import type { WidgetRef, BuildContextRef } from "./common";
import type { RouteName, RouteArguments, RouteRequest } from "./routes";

// ============================================================
// AppRoutes — 路由配置
// ============================================================

/**
 * 应用路由表。
 * 使用 RouteRegistry 替代 GetPage。
 */
export declare class AppRoutes {
  /** 注册路由（委托给 RouteRegistry） */
  static register(name: RouteName, builder: (request: RouteRequest) => WidgetRef): void;

  /** 获取初始路由 */
  static initialRoute: RouteName;
}

// ============================================================
// MyTao996App — 应用入口 Widget
// ============================================================

/** 应用配置选项 */
export interface Tao996AppOptions {
  /** 依赖注入容器 */
  locator: ServiceLocator;
  /** 初始路由 */
  initialRoute?: RouteName;
  /** 是否显示调试标记 */
  debugShowCheckedModeBanner?: boolean;
  /** 备用语言 */
  fallbackLocale?: string;
}

/**
 * 应用根 Widget。
 * 接收 ServiceLocator，使用 MaterialApp + onGenerateRoute。
 */
export declare class MyTao996App {
  constructor(options: Tao996AppOptions);
}

// ============================================================
// Mixin — 控制器 Lifecycle
// ============================================================

/** 页面控制器生命周期 */
export interface PageLifecycle {
  onInit?(): void | Promise<void>;
  onDispose?(): void | Promise<void>;
}

// ============================================================
// NavUtil — 导航工具
// ============================================================

/** 导航工具（基于 Navigator，不依赖 GetX） */
export declare class NavUtil {
  static push<T>(context: BuildContextRef, page: WidgetRef, arguments?: RouteArguments): Promise<T | null>;
  static pop(context: BuildContextRef, result?: any): void;
  static getArguments(context: BuildContextRef): RouteArguments | null;
}

// ============================================================
// 主题快捷访问（替代 Get.theme / Get.context）
// ============================================================

/** 从 Context 获取当前主题亮暗模式 */
export declare function isDarkMode(context: BuildContextRef): boolean;
