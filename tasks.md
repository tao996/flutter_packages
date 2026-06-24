# AI 任务快捷指令

本文档定义了简化的 AI 协作指令，让你用简短的命令完成复杂的工作流。

## 📖 使用方法

在对话中使用格式：`@tasks.md <任务名> <动作> [参数]`

例如：
- `@tasks.md core plan` — 制定 core 阶段计划
- `@tasks.md core 编码` — 开始 core 阶段实现
- `@tasks.md core review` — 审查 core 阶段代码

任务名映射规则：
- `core` → `docs/plans/PLAN_core.md`
- `flutter` → `docs/plans/PLAN_flutter.md`
- `jbook2` → `docs/plans/PLAN_jbook2.md`

---

## 📋 通用动作定义

### `plan` 或 `制定 plan`
为指定任务生成详细实现计划

**必读文件**：
- `docs/PROJECT_STATUS.md` — 当前项目进度
- `docs/PROJECT_RULES.md` — 项目规则
- `docs/remove_get_dependency_plan.md` — 完整重构计划

**AI 执行步骤**：
1. 读取 `docs/PROJECT_STATUS.md` 了解当前进度
2. 读取 `docs/PROJECT_RULES.md` 了解项目约束
3. 读取 `docs/remove_get_dependency_plan.md` 了解架构设计
4. 读取 `specs/` 相关规范文件
5. 生成详细计划，包括：
   - 文件结构设计
   - 核心接口清单
   - 测试策略
   - 实现步骤
6. 保存计划到 `docs/plans/PLAN_{任务名}.md`
7. 更新 `docs/PROJECT_STATUS.md` 记录进度

**输出路径**：`docs/plans/PLAN_{任务名}.md`

---

### `check-plan` 或 `审查计划`
审查已存在的计划文档质量和完整性

**必读文件**：
- `docs/plans/PLAN_{任务名}.md` — 待审查的计划
- `docs/PROJECT_STATUS.md` — 当前进度
- `docs/PROJECT_RULES.md` — 项目规则

**审查维度**：
1. **完整性**：是否覆盖所有必需章节
2. **详细度**：接口定义是否清晰，步骤是否可执行
3. **一致性**：是否与项目现有架构风格一致
4. **可执行性**：技术方案是否可行

**输出**：审查结论追加到 `docs/plans/PLAN_{任务名}.md` 中，以便再次审查

---

### `run` 或 `编码` 或 `实现` 或 `开始`
根据计划实现代码

**必读文件**：
- `docs/plans/PLAN_{任务名}.md` — 实现计划
- `docs/PROJECT_STATUS.md` — 当前状态
- `specs/` 相关规范文件
- 相关的现有代码文件

**AI 执行步骤**：
1. 读取计划文件和规范文件
2. 读取项目中相关的现有代码，了解代码风格
3. 按计划逐步实现代码
4. 编写测试
5. 运行验证：
   ```bash
   # 纯 Dart 库
   cd packages/tao996_core && dart test && dart analyze

   # Flutter 库
   cd packages/tao996_flutter && flutter test && dart analyze
   ```
6. **更新 `docs/PROJECT_STATUS.md`** 记录完成情况

---

### `review` 或 `审查`
审查任务的实现代码

**必读文件**：
- `docs/plans/PLAN_{任务名}.md` — 原计划
- 实现的代码文件
- `docs/PROJECT_RULES.md` — 项目规则

**审查维度**：
1. **完整性**：是否全部实现
2. **正确性**：是否符合 specs 规范
3. **代码质量**：可读性、可维护性
4. **测试覆盖**：是否包含测试
5. **GetX 残留**：是否仍有 `Get.` / `GetIt` / `Obx` 引用

**输出**：
- 审查报告保存到 `docs/reviews/REVIEW_{任务名}.md`
- 问题按优先级分类：🔴 Blocking / 🟡 Should-fix / ⚪ Nits

---

### `fix` 或 `修复`
根据审查报告修复问题

**必读文件**：
- `docs/reviews/REVIEW_{任务名}.md` — 审查报告

**AI 执行步骤**：
1. 读取审查报告
2. 按优先级逐项修复（🔴 → 🟡 → ⚪）
3. 每修复一项运行测试验证
4. 生成修复报告 `docs/reviews/REVIEW_{任务名}_FIX.md`

---

### `commit` 或 `提交` 或 `完成`
提交代码并更新文档

**AI 执行步骤**：
1. 确认测试全部通过
2. 确认 analyze 0 errors
3. 更新 `docs/PROJECT_STATUS.md`（测试数、完成模块）
4. 提交到对应的 git 仓库

---

## 💡 使用示例

```bash
# 制定 tao996_core 计划
@tasks.md core plan

# 实现 flutter 基础架构
@tasks.md flutter 编码

# 审查 flutter 代码
@tasks.md flutter review

# 修复问题
@tasks.md flutter fix

# 提交
@tasks.md flutter commit
```

---

## 📚 当前项目状态

| 包 | 测试 | analyze | 状态 |
|---|:----:|:-------:|:----:|
| `tao996_core` | **205** | 0 errors | ✅ 完成 |
| `tao996_flutter` | **56** | 0 errors | ✅ 基础就绪 |
| `jbook2` | — | — | ⏳ 骨架 |

## 🔗 相关文档

- **进度追踪**：`docs/PROJECT_STATUS.md`
- **项目规则**：`docs/PROJECT_RULES.md`
- **重构计划**：`docs/remove_get_dependency_plan.md`
- **规范文件**：`specs/core/`、`specs/flutter/`
- **计划目录**：`docs/plans/`
- **审查目录**：`docs/reviews/`

## 🚫 禁止的写法（自动审查项）

```dart
// ❌ 禁止：全局 Service Locator
final service = getIMessageService();
final controller = tu.get.getController<MyController>();

// ❌ 禁止：GetX
Get.find(), Get.put(), Get.back(), Get.to(), Get.context
Get.theme, Get.width, GetxController, Obx, GetMaterialApp, GetPage
GetIt.instance

// ✅ 允许
Navigator.pop(context)
Theme.of(context)
MediaQuery.of(context)
RxBuilder(rx: ..., builder: ...)
i18n('key', '中文')
constructor injection
```
