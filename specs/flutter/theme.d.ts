/**
 * 主题规范 — Theme & MediaQuery
 *
 * 替代 Get.theme / Get.textTheme / Get.context / Get.width。
 * 所有主题数据必须来自 BuildContext，禁止全局主题 getter。
 *
 * 生成目标:
 *   Dart → Theme.of(context), MediaQuery.of(context)
 *   ArkTS → @Styles, @Extend
 *   Kotlin → MaterialTheme, LocalDensity
 *   Swift → @Environment(\.colorScheme)
 */

import type { BuildContextRef, ColorValue } from "./common";

/** 亮度 */
export type Brightness = "light" | "dark";

/** 主题规格 */
export interface ThemeSpec {
  brightness: Brightness;
  primaryColor?: ColorValue;
  backgroundColor?: ColorValue;
  surfaceColor?: ColorValue;
  textColor?: ColorValue;
  dividerColor?: ColorValue;
}

/** 文本主题规格 */
export interface TextThemeSpec {
  displayLarge?: TextStyleSpec;
  headlineMedium?: TextStyleSpec;
  titleLarge?: TextStyleSpec;
  bodyLarge?: TextStyleSpec;
  bodyMedium?: TextStyleSpec;
  labelSmall?: TextStyleSpec;
}

/** 文本样式 */
export interface TextStyleSpec {
  fontSize?: number;
  fontWeight?: string | number;
  color?: ColorValue;
  letterSpacing?: number;
  height?: number;
}

/** 媒体查询规格 */
export interface MediaQuerySpec {
  width: number;
  height: number;
  devicePixelRatio?: number;
  textScaleFactor?: number;
  paddingTop?: number;
  paddingBottom?: number;
}

/** 主题适配器 */
export declare class ThemeAdapter {
  /** 从 Context 获取主题 */
  static themeOf(context: BuildContextRef): ThemeSpec;

  /** 从 Context 获取文本主题 */
  static textThemeOf(context: BuildContextRef): TextThemeSpec;

  /** 从 Context 获取媒体查询 */
  static mediaQueryOf(context: BuildContextRef): MediaQuerySpec;
}
