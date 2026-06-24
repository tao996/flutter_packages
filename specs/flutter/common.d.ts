/**
 * Flutter UI 层公共类型
 *
 * 跨文件共享的基础类型，避免重复定义。
 * 各平台生成时映射到对应原生类型。
 *
 * 生成目标:
 *   Dart → Widget, BuildContext, Color, EdgeInsets, TextStyle
 *   ArkTS → Component, BuildContext, ResourceColor, EdgeInsets, TextStyle
 *   Kotlin → @Composable, Context, Color, Dp, TextStyle
 *   Swift → View, UIViewController, Color, EdgeInsets, Font
 */

/** UI 组件引用（对应 Dart Widget / ArkTS Component / ...） */
export type WidgetRef = unknown;

/** UI 上下文引用（对应 Dart BuildContext / ArkTS BuildContext / ...） */
export type BuildContextRef = unknown;

/** 颜色值 */
export type ColorValue = string | number;

/** 图标值 */
export type IconValue = string | number;

/** 无参回调 */
export type VoidCallback = () => void;

/** 值变化回调 */
export type ValueChanged<T> = (value: T) => void;

/** 尺寸规格 */
export interface SizeSpec {
  width: number;
  height: number;
}

/** 内边距规格 */
export interface EdgeInsetsSpec {
  left?: number;
  top?: number;
  right?: number;
  bottom?: number;
}

/** 文本样式规格 */
export interface TextStyleSpec {
  fontSize?: number;
  fontWeight?: string | number;
  color?: ColorValue;
}
