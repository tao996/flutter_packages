/**
 * 翻译管理器 — TranslationManager
 *
 * 多语言 key-value 查找 + 参数替换。纯 Dart / ArkTS / Kotlin / Swift 通用。
 *
 * 生成目标:
 *   Dart → class TranslationManager + extension StringTranslateExt
 *   ArkTS → class TranslationManager + extension StringTranslateExt
 *   Kotlin → object TranslationManager + String.translate()
 *   Swift → class TranslationManager + String.translate
 */

/**
 * 翻译管理器（全局单例）
 */
declare class TranslationManager {
  static get instance(): TranslationManager;

  /** 当前语言代码，如 'zh_CN', 'en_US' */
  get currentLocale(): string;

  /** 支持的语言列表 */
  get supportedLocales(): string[];

  /** 设置当前语言 */
  setLocale(locale: string): void;

  /** 添加翻译字典 */
  addDict(keys: Record<string, Record<string, string>>): void;

  /** 添加单语言翻译 */
  addKeys(keys: Record<string, string>, locale?: string): void;

  /** 翻译 key。找不到返回 key 本身。params 替换 {param} 占位符 */
  translate(key: string, params?: Record<string, string>): string;

  /**
   * i18n — 带默认中文文案的翻译（推荐主 API）。
   *
   * @param key 翻译键
   * @param zh 默认中文文案，找不到翻译时回退
   * @param params 参数替换，支持 @name / {name} / {{name}} 占位符
   * @param namespace 命名空间，非空时优先查 `namespace.key`
   */
  i18n(
    key: string,
    zh: string,
    params?: Record<string, string | number | boolean>,
    namespace?: string,
  ): string;

  /** 重置（用于测试） */
  reset(): void;
}

/**
 * 全局 i18n 函数 — 最便捷的翻译 API。
 *
 * ```typescript
 * i18n('hello', '你好')
 * i18n('yourAgeIs', '你的年龄是@age', { age: 15 })
 * ```
 */
declare function i18n(
  key: string,
  zh: string,
  params?: Record<string, string | number | boolean>,
  namespace?: string,
): string;

/**
 * 兼容 .tr 扩展
 */
declare interface String {
  get tr(): string;
  trParams(params: Record<string, string>): string;
}
