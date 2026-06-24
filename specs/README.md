# spec 规范目录

本项目采用 **Specs-First** 开发模式。

## 规则

1. **唯一真相源**：`specs/core/*.d.ts` 定义所有接口/类型
2. **代码由 AI 生成**：人工只改 `.d.ts`，不直接修改生成的实现代码
3. **生成四端**：同一份 `.d.ts` → Dart / ArkTS / Kotlin / Swift

## 目录结构

```
specs/
├── README.md
├── core/                     → 对应 tao996_core（纯 Dart 核心库）
│   ├── di.d.ts               ✅ ServiceLocator
│   ├── reactive.d.ts         ✅ Rx / RxList / RxBool / RxInt / Computed
│   ├── utils.d.ts            ✅ Array / Crypto / Filepath / Number / Data /
│   │                           Datetime / Text / Fn / Stack / Cast /
│   │                           Json / Result / Validator / Exception
│   ├── translation.d.ts      ✅ TranslationManager
│   ├── event.d.ts            ✅ EventBus
│   ├── db.d.ts               ✅ IModel / QueryBuilder / Repository / Migration
│   └── services.d.ts         ✅ 服务接口规范
├── flutter/                  → 对应 tao996_flutter（Flutter UI）
│   ├── common.d.ts           ✅ 公共 UI 类型（WidgetRef/ColorValue/等）
│   ├── routes.d.ts           ✅ RouteRegistry / NavigationAdapter
│   ├── rx_builder.d.ts       ✅ RxBuilder / RxBoolBuilder / RxBuilder2
│   ├── widgets.d.ts          ✅ 20+ UI 组件
│   ├── pages.d.ts            ✅ 6 个页面组件
│   ├── services.d.ts         ✅ Flutter 依赖注册 + 平台适配
│   ├── app.d.ts              ✅ AppRoutes / MyTao996App / PageLifecycle
│   ├── platform.d.ts         ✅ IPlatformService / PlatformInfo
│   ├── i18n.d.ts             ✅ Flutter 国际化运行时
│   └── theme.d.ts            ✅ ThemeAdapter / MediaQuerySpec
└── jbook/                    → 对应 jbook2（应用层）⏳
```

## 当前覆盖度

| 规范文件 | `tao996_core` Dart 实现 | 测试数 |
|---------|------------------------|--------|
| `core/di.d.ts` | ✅ 7 methods | 7 |
| `core/reactive.d.ts` | ✅ 5 classes | 24 |
| `core/utils.d.ts` | ✅ 14 classes | 70 |
| `core/translation.d.ts` | ✅ 1 class + extension | 9 |
| `core/event.d.ts` | ✅ 2 classes | 4 |
| `core/db.d.ts` | ✅ 6 classes | 19 |
| `core/services.d.ts` | （接口层，实现放 flutter） | — |
| **合计** | **24 个导出模块** | **196** ✅ |

## 类型映射

| TS 类型 | Dart | ArkTS | Kotlin | Swift |
|---------|------|-------|--------|-------|
| `string` | `String` | `string` | `String` | `String` |
| `number` | `int` / `double` | `number` | `Int` / `Double` | `Int` / `Double` |
| `boolean` | `bool` | `boolean` | `Boolean` | `Bool` |
| `T[]` | `List<T>` | `T[]` | `List<T>` | `[T]` |
| `Promise<T>` | `Future<T>` | `Promise<T>` | `suspend fun` | `async throws -> T` |
| `T \| null` | `T?` | `T \| null` | `T?` | `T?` |
| `interface` | `abstract class` | `interface` | `interface` | `protocol` |
| `class` | `class` | `class` | `class` | `class` |
