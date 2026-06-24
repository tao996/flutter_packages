/**
 * 平台服务规范 — Platform Service
 *
 * 获取运行平台信息，替代 GetX 的平台判断。
 *
 * 生成目标:
 *   Dart → class PlatformService (使用 dart:io / Platform / flutter)
 *   ArkTS → class PlatformService (使用 @ohos.common)
 *   Kotlin → class PlatformService (使用 Build / android.os)
 *   Swift → class PlatformService (使用 UIDevice / ProcessInfo)
 */

/** 平台类型 */
export type PlatformType =
  | "android" | "ios" | "macos" | "windows" | "linux"
  | "web" | "harmony" | "unknown";

/** 平台信息 */
export interface PlatformInfo {
  type: PlatformType;
  osVersion?: string;
  appVersion?: string;
  buildNumber?: string;
  deviceModel?: string;
  isPhysicalDevice?: boolean;
}

/** 平台服务接口 */
export declare interface IPlatformService {
  /** 获取平台信息 */
  getInfo(): Promise<PlatformInfo>;

  /** 是否 Web */
  isWeb(): boolean;

  /** 是否移动端 */
  isMobile(): boolean;

  /** 是否桌面端 */
  isDesktop(): boolean;
}
