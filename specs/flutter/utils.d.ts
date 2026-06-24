/**
 * Flutter Utils 接口规范
 *
 * 覆盖 tao996_flutter/lib/src/utils 中所有工具类。
 */

// ============================================================
// FormHelper — 表单辅助工具
// ============================================================
/**
 * 表单辅助工具类 - 提供常用表单组件的快捷方法。
 *
 * 实现位置：tao996_flutter/lib/src/utils/form_helper.dart
 */
declare class FormHelper {
  private constructor();

  /**
   * 生成表单 key，用于表单验证。
   *
   * @example
   * ```dart
   * final formKey = FormHelper.formKey();
   * if (formKey.currentState!.validate()) {
   *   // 验证通过
   * }
   * ```
   */
  static formKey(): any;

  /**
   * 泛型下拉选择框。
   *
   * @param label 标签文本
   * @param items KV 列表（选项）
   * @param value 当前选中值
   * @param onChanged 值变化回调
   * @param isRequired 是否必填（默认 false）
   * @param validator 自定义验证器
   *
   * @example
   * ```dart
   * FormHelper.select<String>(
   *   label: 'Category',
   *   items: [
   *     KV(label: 'Technology', value: 'tech'),
   *     KV(label: 'Science', value: 'science'),
   *   ],
   *   value: selectedValue,
   *   onChanged: (value) => setState(() => selectedValue = value),
   *   isRequired: true,
   * )
   * ```
   */
  static select<T>(props: {
    label: string;
    items: KV<T>[];
    value: T | null;
    onChanged: (value: T | null) => void;
    isRequired?: boolean;
    validator?: (value: T | null) => string | null;
  }): any;

  /**
   * 多选 FilterChip 组件（Material 3 风格）。
   *
   * @param context BuildContext
   * @param items KV 列表（选项）
   * @param selectedValues 已选中的值列表
   * @param onChanged 选择变化回调
   * @param label 顶部标签（可选）
   *
   * @example
   * ```dart
   * FormHelper.filterChipCheckbox<int>(
   *   context: context,
   *   items: tags.map((t) => KV(label: t.name, value: t.id)).toList(),
   *   selectedValues: member.tagIds,
   *   onChanged: (selected) => setState(() => member.tagIds = selected),
   *   label: '选择标签',
   * )
   * ```
   */
  static filterChipCheckbox<T>(props: {
    context: any;
    items: KV<T>[];
    selectedValues: T[];
    onChanged: (selected: T[]) => void;
    label?: string;
  }): any;

  /**
   * 单选 FilterChip 组件。
   *
   * @param context BuildContext
   * @param items KV 列表（选项）
   * @param value 当前选中值
   * @param onChanged 选择变化回调
   * @param label 顶部标签（可选）
   */
  static oneFilterChip<T>(props: {
    context: any;
    items: KV<T>[];
    value: T | null;
    onChanged: (value: T | null) => void;
    label?: string;
  }): any;

  /**
   * Material 3 分段按钮（SegmentedButton）。
   *
   * @param context BuildContext
   * @param items KV 列表（选项）
   * @param selectedValues 已选中的值列表（多选）
   * @param onChanged 选择变化回调
   * @param multiSelectionEnabled 是否允许多选（默认 false）
   *
   * @example
   * ```dart
   * FormHelper.segmentedButton<String>(
   *   context: context,
   *   items: [
   *     KV(label: 'Day', value: 'day'),
   *     KV(label: 'Week', value: 'week'),
   *     KV(label: 'Month', value: 'month'),
   *   ],
   *   selectedValues: [viewMode],
   *   onChanged: (selected) => setState(() => viewMode = selected.first),
   * )
   * ```
   */
  static segmentedButton<T>(props: {
    context: any;
    items: KV<T>[];
    selectedValues: T[];
    onChanged: (selected: T[]) => void;
    multiSelectionEnabled?: boolean;
  }): any;

  /**
   * 将自定义 Widget 包装为标准表单字段（带 InputDecoration）。
   *
   * @param label 标签文本
   * @param child 自定义 Widget
   * @param validator 验证器（可选）
   * @param errorText 错误提示（可选）
   *
   * @example
   * ```dart
   * FormHelper.inputDecoration(
   *   label: 'Custom Field',
   *   child: MyCustomWidget(),
   *   validator: (value) => value == null ? 'Required' : null,
   * )
   * ```
   */
  static inputDecoration(props: {
    label: string;
    child: any;
    validator?: (value: any) => string | null;
    errorText?: string;
  }): any;
}

// ============================================================
// ColorUtil — 颜色工具
// ============================================================
/**
 * 颜色工具类 - 提供颜色解析、转换、透明度判断等功能。
 *
 * 实现位置：tao996_flutter/lib/src/utils/color_util.dart
 */
declare class ColorUtil {
  private constructor();

  /** 判断颜色是否完全透明（alpha = 0）。*/
  static isFullyTransparent(color: any): boolean;

  /** 判断颜色是否有透明度（alpha < 255）。*/
  static isTransparent(color: any): boolean;

  /**
   * 将十六进制颜色字符串转换为 Color。
   *
   * @param hex 十六进制颜色（如 '#fef7ff' 或 'fef7ff'）
   * @param opacity 透明度（0.0 - 1.0，可选）
   * @returns Color 对象
   *
   * @example
   * ```dart
   * final color = ColorUtil.hexToColor('#fef7ff', opacity: 0.5);
   * ```
   */
  static hexToColor(hex: string, opacity?: number): any;

  /**
   * 将 RGB 字符串转换为 Color。
   *
   * @param rgb RGB 字符串（如 '255, 247, 255'）
   * @param opacity 透明度（0.0 - 1.0，可选）
   * @returns Color 对象
   *
   * @example
   * ```dart
   * final color = ColorUtil.rgbToColor('255, 247, 255', opacity: 0.8);
   * ```
   */
  static rgbToColor(rgb: string, opacity?: number): any;

  /**
   * 智能解析颜色字符串（支持 hex 和 rgb 格式）。
   *
   * @param colorString 颜色字符串（hex 或 rgb）
   * @returns Color 对象或 null
   */
  static parseToColor(colorString: string): any | null;

  /**
   * 构建棋盘背景（用于显示透明色）。
   *
   * @param squareSize 方格大小（默认 10）
   * @returns Widget（CustomPaint）
   *
   * @example
   * ```dart
   * Stack(
   *   children: [
   *     ColorUtil.buildCheckerboard(squareSize: 8),
   *     Container(color: Colors.blue.withOpacity(0.5)),
   *   ],
   * )
   * ```
   */
  static buildCheckerboard(squareSize?: number): any;

  /**
   * 从 ColorScheme 获取成功色（绿色语义）。
   */
  static success(colorScheme: any): any;

  /**
   * 从 ColorScheme 获取错误色（红色语义）。
   */
  static error(colorScheme: any): any;

  /**
   * 从 ColorScheme 获取警告色（橙色语义）。
   */
  static warning(colorScheme: any): any;

  /**
   * 从 ColorScheme 获取信息色（蓝色语义）。
   */
  static info(colorScheme: any): any;
}

// ============================================================
// ContextUtil — BuildContext 工具
// ============================================================
/**
 * BuildContext 工具类 - 提供常用上下文操作。
 *
 * 实现位置：tao996_flutter/lib/src/utils/context_util.dart
 */
declare class ContextUtil {
  private constructor();

  /**
   * 关闭键盘焦点。
   *
   * @param context BuildContext
   */
  static unfocus(context: any): void;

  /**
   * 获取屏幕宽度。
   *
   * @param context BuildContext
   * @returns 屏幕宽度（double）
   */
  static screenWidth(context: any): number;

  /**
   * 获取屏幕高度。
   *
   * @param context BuildContext
   * @returns 屏幕高度（double）
   */
  static screenHeight(context: any): number;

  /**
   * 获取当前主题的 ColorScheme。
   *
   * @param context BuildContext
   * @returns ColorScheme 对象
   */
  static colorScheme(context: any): any;
}

// ============================================================
// UrlUtil — URL 工具
// ============================================================
/**
 * URL 工具类 - 提供 URL 打开、验证、MIME 类型判断等功能。
 *
 * 实现位置：tao996_flutter/lib/src/utils/url_util.dart
 */
declare class UrlUtil {
  private constructor();

  /**
   * 打开 URL（浏览器或外部应用）。
   *
   * @param url URL 字符串
   * @returns Result<void, string>（成功或错误信息）
   *
   * @example
   * ```dart
   * final result = await UrlUtil.openUrl('https://example.com');
   * result.match(
   *   ok: (_) => print('Opened'),
   *   err: (error) => print('Error: $error'),
   * );
   * ```
   */
  static openUrl(url: string): Promise<Result<void, string>>;

  /**
   * 验证 URL 是否有效。
   *
   * @param url URL 字符串
   * @returns 是否有效
   */
  static isValidUrl(url: string): boolean;

  /**
   * 根据文件扩展名获取 MIME 类型。
   *
   * @param extension 文件扩展名（如 'png', '.jpg'）
   * @returns MIME 类型字符串（如 'image/png'）
   *
   * @example
   * ```dart
   * final mime = UrlUtil.getMimeType('png'); // 'image/png'
   * ```
   */
  static getMimeType(extension: string): string | null;
}

// ============================================================
// PermissionUtil — 权限工具
// ============================================================
/**
 * 权限工具类 - 提供权限请求封装。
 *
 * 实现位置：tao996_flutter/lib/src/utils/permission_util.dart
 */
declare class PermissionUtil {
  private constructor();

  /**
   * 请求权限。
   *
   * @param permission 权限类型（来自 permission_handler 包）
   * @returns 是否授权
   *
   * @example
   * ```dart
   * final granted = await PermissionUtil.request(Permission.camera);
   * if (granted) {
   *   // 使用相机
   * }
   * ```
   */
  static request(permission: any): Promise<boolean>;
}
