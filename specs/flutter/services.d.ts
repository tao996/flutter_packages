/**
 * Flutter 服务实现注册规范
 *
 * 只描述 Flutter 层服务的注册和配置，不重复定义 core 中的服务接口。
 * 所有服务实现接收外部 ServiceLocator，不创建全局 locator。
 *
 * 生成目标:
 *   Dart → setupTao996FlutterDependencies(locator)
 *   ArkTS → setupTao996HmDependencies(locator)
 *   Kotlin → Tao996AndroidDependencies.setup(locator)
 *   Swift → setupTao996IOSDependencies(locator)
 */

import type { ServiceLocator } from "../core/di";
import type { PlatformInfo, PlatformType } from "./platform";

/** Flutter 层依赖注册选项 */
export interface FlutterDependencySetupOptions {
  locator: ServiceLocator;
  platform?: PlatformType;
}

/** Flutter 层依赖注册函数 */
export declare function setupTao996FlutterDependencies(
  options: FlutterDependencySetupOptions
): ServiceLocator;

// ============================================================
// Flutter 平台信息
// ============================================================

export interface FlutterPlatformInfo extends PlatformInfo {
  /** Flutter 引擎版本 */
  flutterVersion?: string;
  /** Dart SDK 版本 */
  dartSdkVersion?: string;
}

// ============================================================
// Flutter 主题构建器
// ============================================================

export type FlutterThemeData = unknown; // 映射到 Dart ThemeData

export interface IFlutterThemeBuilder {
  buildLightTheme(dynamicColor: any): FlutterThemeData;
  buildDarkTheme(dynamicColor: any): FlutterThemeData;
}

// ============================================================
// Flutter 数据库配置
// ============================================================

export interface DatabaseConfig {
  databaseName: string;
  databaseDir?: string;
  printSQL?: boolean;
}
