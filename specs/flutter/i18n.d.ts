/**
 * i18n — 运行时翻译函数（Flutter 层集成）
 *
 * 翻译字典和核心逻辑在 core/translation 中定义。
 * 本文件定义 `i18n()` 函数签名，作为 Flutter 层的主翻译 API。
 *
 * 替代 GetX 的 '.key'.tr / .trParams。
 *
 * 使用方式:
 * ```dart
 * Text(i18n('hello', '你好'))
 * Text(i18n('yourAgeIs', '你的年龄是@age', { age: 15 }))
 * Text(i18n('title', '书籍', undefined, 'book'))
 * ```
 *
 * 生成目标:
 *   Dart → function i18n(key, zh, {params?, namespace?})
 *   ArkTS → function i18n(key, zh, params?, namespace?)
 *   Kotlin → fun i18n(key, zh, params, namespace)
 *   Swift → func i18n(_ key, _ zh, params, namespace)
 */

import type { LocaleCode, TranslationParams } from "../core/translation";

/** i18n 选项 */
export interface I18nOptions {
  params?: Record<string, string | number | boolean | null>;
  namespace?: string;
}

/** i18n 翻译函数 */
export declare function i18n(
  key: string,
  zh: string,
  options?: I18nOptions,
): string;

/** Flutter 国际化配置 */
export interface FlutterI18nOptions {
  initialLocale: LocaleCode;
  fallbackLocale?: LocaleCode;
  dict?: Record<LocaleCode, Record<string, string>>;
}

/** Flutter 国际化运行时接口 */
export declare interface IFlutterI18nRuntime {
  setLocale(locale: LocaleCode): void;
  getCurrentLocale(): LocaleCode;
  translate(key: string, params?: TranslationParams): string;
  addDict(dict: Record<LocaleCode, Record<string, string>>): void;
}
