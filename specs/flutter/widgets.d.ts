/**
 * Flutter UI 组件接口规范
 *
 * 覆盖 tao996_flutter 中所有公开 UI 组件。
 * AI 根据此规范生成 Dart Flutter 实现。
 */

// ============================================================
// RxBuilder — 响应式 UI
// ============================================================
/**
 * 监听单个 Rx，值变化时重建 Widget。
 * ```dart
 * RxBuilder(rx: count, builder: (ctx, v) => Text('$v'))
 * ```
 */
declare class RxBuilder<T> {
  constructor(props: { rx: Rx<T>; builder: (context: any, value: T) => any; key?: any });
}

/**
 * 监听多个 Rx，任一变化时重建。
 * ```dart
 * RxBuilder2(deps: [a, b], builder: (ctx) => Text('${a.value}'))
 * ```
 */
declare class RxBuilder2 {
  constructor(props: { deps: ReadonlyRx<any>[]; builder: (context: any) => any; key?: any });
}

// ============================================================
// MyScaffold — 页面骨架
// ============================================================
declare class MyScaffold {
  constructor(props: {
    appBar?: any;
    drawer?: any;
    body: any;
    floatingActionButton?: any;
    bottomNavigationBar?: any;
    bottomSheet?: any;
    backgroundColor?: string;
    useSafeArea?: boolean;
    singleChildScrollView?: boolean;
    unfocusOnTap?: boolean;
    drawerEdgeDragWidthPercent?: number;
    key?: any;
  });
}

declare class MyMiniScaffold {
  constructor(props: { appBar: any; children: any[]; floatingActionButton?: any; key?: any });
}

// ============================================================
// MyButton — 多功能按钮
// ============================================================
type MyButtonStatus = 'primary' | 'secondary' | 'danger' | 'warning' | 'success' | 'info';
type MyButtonType = 'outlined' | 'text' | 'filled' | 'filledTonal' | 'elevated';

declare class MyButton {
  constructor(props: {
    label: string;
    icon?: any;
    iconData?: any;
    onPressed?: () => void;
    status?: MyButtonStatus;
    isLoading?: RxBool;
    type?: MyButtonType;
    radius?: number;
    padding?: any;
    size?: number;
    tooltip?: string;
    key?: any;
  });
}

declare class MySaveButton {
  constructor(props: { onPressed?: () => void; isLoading?: RxBool; label?: string; key?: any });
}

declare class MyCancelButton {
  constructor(props: { onPressed?: () => void; key?: any });
}

declare class MyDeleteButton {
  constructor(props: { onPressed?: () => void; confirm?: boolean; title?: string; content?: string; key?: any });
}

declare class MyInsertButton {
  constructor(props: { label?: string; onPressed?: () => void; key?: any });
}

declare class MyMenuButtons {
  constructor(props: { items: MyMenuButtonItem[][]; key?: any });
}

declare class MyMenuButtonItem {
  text: string;
  iconData?: any;
  color?: string;
  onPressed: () => Promise<void>;
}

// ============================================================
// MyDialog — 对话框
// ============================================================
declare class MyDialog {
  static title(title: string, props?: { titleWidget?: any; actions?: any[]; replace?: boolean }): any;
  static close(): void;
  static open(context: any, props: { child: any; width?: number; height?: number; fullScreen?: boolean }): Promise<any>;
  static fullScreenDialog(context: any, props: { child: any; width?: number; height?: number; key?: any }): Promise<any>;
  static form(context: any, props: { title: string; children: any[]; onSubmit: () => void; onDelete?: () => void; fullScreen?: boolean; key?: any }): Promise<void>;
  static radioList<T>(props: { title: string; items: KV<T>[]; value?: T; onSubmit: (v: T | null) => void; icon?: any }): void;
  static showBottomSheet<T>(context: any, props: { child: any; scrollView?: boolean }): Promise<T | null>;
  static showTopSheet<T>(context: any, props: { child: any; scrollView?: boolean }): Promise<T | null>;
}

// ============================================================
// MyLoading — 加载指示器
// ============================================================
declare class MyLoading {
  constructor(props: { key?: any });
}

declare function myAppBarLoading(isLoading: RxBool): any;

// ============================================================
// MyImageCache — 缓存图片
// ============================================================
declare class MyImageCache {
  constructor(props: { data: any; onTap?: () => void; enabledTap?: boolean; size?: number; key?: any });
}

// ============================================================
// MyFont — 字体选择
// ============================================================
declare class MyFont {
  showFontPickerDialog(context: any, props: { onChange?: (font: string) => void }): void;
  build(context: any, fontFamily: string, props: { onChange?: (font: string) => void }): any;
}

// ============================================================
// MyTags — 标签组件
// ============================================================
declare class MyTagsManager {
  constructor(props: { values: string[]; label?: string; hintText?: string; onChanged?: (tags: string[]) => void; key?: any });
}

declare class MyTag {
  static text(context: any, text: string, props?: { onPressed?: () => void }): any;
  static primary(context: any, text: string, props?: { onPressed?: () => void }): any;
  static gray(context: any, text: string): any;
  static highlight(context: any, text: string): any;
  static wrap(tags: any[]): any;
}

// ============================================================
// MyReorder — 拖拽排序
// ============================================================
declare class MyReorder<T> {
  constructor(
    items: RxList<T>,
    props: {
      itemBuilder: (context: any, index: number) => any;
      emptyWidget?: any;
      onReorder?: (oldIndex: number, newIndex: number) => void;
      key?: any;
    },
  );
}

// ============================================================
// MyCustomTabBar — 自定义标签栏
// ============================================================
type MyCustomTabBarStyle = 'horizontal' | 'flow' | 'bookMark' | 'flowChip';

declare class MyCustomTabBar {
  constructor(props: {
    children: MyCustomTabBarItem[];
    activeIndex: RxInt;
    onChange: (index: number) => void;
    onDoubleTap?: (index: number) => void;
    style?: MyCustomTabBarStyle;
    height?: number;
    onInsert?: () => void;
    key?: any;
  });
}

declare class MyCustomTabBarItem {
  key: string;
  title: string;
}

// ============================================================
// MyListTile — 列表项
// ============================================================
declare class MyListTile {
  static build(props: {
    titleText: string;
    subtitle?: any;
    trailing?: any;
    leading?: any;
    onTitleTap?: () => void;
    contentPadding?: any;
    key?: any;
  }): any;
}

// ============================================================
// MyEmptyState — 空状态
// ============================================================
declare class MyEmptyStateWidget {
  constructor(props: { titleText?: string; onPressed?: () => void; key?: any });
}

declare class MyEmptyStateLayout {
  constructor(props: { titleText: string; descText?: string; buttonText?: string; onPressed?: () => void; key?: any });
}

// ============================================================
// 布局 / 填充 / 事件
// ============================================================
declare class MyBodyPadding {
  constructor(child: any, props?: { horizontal?: number; vertical?: number });
}

declare class MyPadding {
  constructor(props: { child: any; horizontal?: number; vertical?: number; left?: number; right?: number; top?: number; bottom?: number; key?: any });
}

declare class MyLayout {
  static miniColumn(children: any[]): any;
  static row(children: any[], props?: { mainAxis?: any; crossAxis?: any }): any;
}

declare class MyEvents {
  static unfocusOnTap(child: any): any;
  static inkWell(props: { onTap?: () => void; child: any }): any;
}

declare class MyIconSvg {
  constructor(data: any, props?: { size?: number; color?: string });
}

// ============================================================
// 输入组件
// ============================================================
declare class MyInput {
  constructor(props: {
    label: string;
    controller?: any;
    hintText?: string;
    onChanged?: (text: string) => void;
    validator?: (text: string) => string | null;
    obscureText?: boolean;
    maxLines?: number;
    suffixIcon?: any;
    key?: any;
  });
}

// ============================================================
// KV 工具类型（已移至 tao996_core）
// ============================================================
/**
 * KV 类型定义已迁移到 tao996_core/specs/core/utils.d.ts
 * 此处保留引用以保持兼容性。
 */
declare class KV<T> {
  label: string;
  value: T;
}

// ============================================================
// GridCheckbox — 网格多选组件
// ============================================================
/**
 * 泛型网格多选组件 - 支持响应式布局和主题适配。
 *
 * 实现位置：tao996_flutter/lib/src/ui/widgets/grid_checkbox.dart
 *
 * @example
 * ```dart
 * GridCheckbox<int>(
 *   items: tags.map((t) => KV(label: t.name, value: t.id)).toList(),
 *   selectedValues: member.tagIds,
 *   onChanged: (selected) => setState(() => member.tagIds = selected),
 *   crossAxisCount: 3,
 * )
 * ```
 */
declare class GridCheckbox<T> {
  constructor(props: {
    items: KV<T>[];
    selectedValues: T[];
    onChanged: (selected: T[]) => void;
    crossAxisCount?: number;
    key?: any;
  });
}

// ============================================================
// ListCheckbox — 列表多选组件
// ============================================================
/**
 * 泛型列表多选组件。
 *
 * 实现位置：tao996_flutter/lib/src/ui/widgets/list_checkbox.dart
 *
 * @example
 * ```dart
 * ListCheckbox<String>(
 *   items: [
 *     KV(label: 'Option A', value: 'a'),
 *     KV(label: 'Option B', value: 'b'),
 *   ],
 *   selectedValues: ['a'],
 *   onChanged: (selected) => print(selected),
 * )
 * ```
 */
declare class ListCheckbox<T> {
  constructor(props: {
    items: KV<T>[];
    selectedValues: T[];
    onChanged: (selected: T[]) => void;
    key?: any;
  });
}

// ============================================================
// MyInputLabel + MyTextArea — 表单输入辅助
// ============================================================
/**
 * 表单标签组件（带必填星号）。
 *
 * 实现位置：tao996_flutter/lib/src/ui/widgets/input_helper.dart
 *
 * @example
 * ```dart
 * MyInputLabel('姓名', required: true)
 * ```
 */
declare class MyInputLabel {
  constructor(text: string, props?: { required?: boolean; key?: any });
}

/**
 * 多行文本输入组件。
 *
 * 实现位置：tao996_flutter/lib/src/ui/widgets/input_helper.dart
 *
 * @example
 * ```dart
 * MyTextArea(
 *   controller: remarkController,
 *   hintText: '备注信息',
 *   maxLines: 5,
 * )
 * ```
 */
declare class MyTextArea {
  constructor(props: {
    controller: any;
    hintText?: string;
    maxLines?: number;
    key?: any;
  });
}

// ============================================================
// MyTable — 表格组件
// ============================================================
/**
 * 表格组件（Material Design 风格）。
 *
 * 实现位置：tao996_flutter/lib/src/ui/widgets/table.dart
 *
 * @example
 * ```dart
 * MyTable(
 *   headers: ['Name', 'Age', 'City'],
 *   rows: [
 *     ['Alice', '25', 'Beijing'],
 *     ['Bob', '30', 'Shanghai'],
 *   ],
 * )
 * ```
 */
declare class MyTable {
  constructor(props: {
    headers: string[];
    rows: string[][];
    key?: any;
  });
}

/**
 * 表格构建器（自定义单元格）。
 *
 * @example
 * ```dart
 * myTableBuilder(
 *   headers: ['Name', 'Actions'],
 *   rows: users.map((u) => [
 *     Text(u.name),
 *     IconButton(icon: Icon(Icons.edit), onPressed: () {}),
 *   ]).toList(),
 * )
 * ```
 */
declare function myTableBuilder(props: {
  headers: string[];
  rows: any[][];
}): any;

// ============================================================
// SeparatorLine — 分隔线
// ============================================================
/**
 * 分隔线组件（垂直或水平）。
 *
 * 实现位置：tao996_flutter/lib/src/ui/widgets/separator_line.dart
 *
 * @example
 * ```dart
 * SeparatorLine(vertical: true, height: 20)
 * ```
 */
declare class SeparatorLine {
  constructor(props?: { vertical?: boolean; height?: number; key?: any });
}

// ============================================================
// Avatar — 头像组件
// ============================================================
/**
 * 头像组件（支持图片/首字母/图标）。
 *
 * 实现位置：tao996_flutter/lib/src/ui/widgets/avatar.dart
 *
 * @example
 * ```dart
 * Avatar(name: 'Alice', radius: 30)
 * Avatar(imageUrl: 'https://...', radius: 30)
 * Avatar(icon: Icons.person, radius: 30)
 * ```
 */
declare class Avatar {
  constructor(props: {
    name?: string;
    imageUrl?: string;
    icon?: any;
    radius?: number;
    key?: any;
  });
}

// ============================================================
// Icon Widgets — 图标组件
// ============================================================
/**
 * 动画图标组件。
 *
 * 实现位置：tao996_flutter/lib/src/ui/widgets/icon_widgets.dart
 */
declare class MyAnimatedIcon {
  constructor(props: {
    icon: any;
    progress: any;
    size?: number;
    color?: any;
    key?: any;
  });
}

/**
 * SVG 图标组件（来自 flutter_svg）。
 *
 * 实现位置：tao996_flutter/lib/src/ui/widgets/icon_widgets.dart
 *
 * @example
 * ```dart
 * MyIconSvg('assets/icons/logo.svg', size: 24, color: Colors.blue)
 * ```
 */
declare class MyIconSvg {
  constructor(assetPath: string, props?: { size?: number; color?: any; key?: any });
}

// ============================================================
// MyLayout — 布局辅助
// ============================================================
/**
 * 布局辅助工具类。
 *
 * 实现位置：tao996_flutter/lib/src/ui/widgets/layout.dart
 */
declare class MyLayout {
  /** 最小间距列布局（mainAxisSize.min）*/
  static miniColumn(children: any[]): any;

  /** 最小间距行布局 */
  static miniRow(children: any[]): any;

  /** 标准行布局（可指定主轴/交叉轴对齐）*/
  static row(children: any[], props?: { mainAxis?: any; crossAxis?: any }): any;

  /** 高度为 8 的 SizedBox */
  static height8(): any;

  /** 宽度为 8 的 SizedBox */
  static width8(): any;
}

/**
 * 卡片封装（带圆角和内边距）。
 *
 * @example
 * ```dart
 * myCard(child: Text('Content'), radius: 12, padding: 16)
 * ```
 */
declare function myCard(props: {
  child: any;
  radius?: number;
  padding?: number;
}): any;

// ============================================================
// MyText — 文本组件
// ============================================================
/**
 * 文本组件工具类（Material Design 排版）。
 *
 * 实现位置：tao996_flutter/lib/src/ui/widgets/text.dart
 */
declare class MyText {
  /** 标题 1（displayLarge）*/
  static h1(context: any, text: string): any;

  /** 标题 2（displayMedium）*/
  static h2(context: any, text: string): any;

  /** 标题 3（displaySmall）*/
  static h3(context: any, text: string): any;

  /** 标题 4（headlineMedium）*/
  static h4(context: any, text: string): any;

  /** 标题 5（headlineSmall）*/
  static h5(context: any, text: string): any;

  /** 标题 6（titleLarge）*/
  static h6(context: any, text: string): any;

  /** 描述文本（bodySmall + secondary color）*/
  static desc(context: any, text: string): any;

  /** 粗体文本 */
  static bold(context: any, text: string): any;

  /** 章节标题 */
  static sectionTitle(context: any, text: string): any;
}

/**
 * 文本样式预设。
 */
declare class TextStyles {
  /** 粗体样式 */
  static bold(): any;

  /** 中等粗细样式 */
  static medium(): any;
}
