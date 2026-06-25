.PHONY: help deps analyze test test-watch test-int run build clean

# ─── 帮助 ───────────────────────────────────────────────────
help: ## 显示此帮助
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# ─── 依赖 ───────────────────────────────────────────────────
deps: ## 安装依赖（flutter pub get）
	flutter pub get

# ─── 静态分析 ───────────────────────────────────────────────
analyze: ## 运行静态分析（0 issues 为通过）
	flutter analyze

# ─── 测试 ───────────────────────────────────────────────────
test: ## 运行全部单元测试 + Widget 测试
	flutter test

test-watch: ## 监听模式运行测试（文件变更自动重跑）
	flutter test --watch

test-coverage: ## 运行测试并生成覆盖率报告
	flutter test --coverage
	@echo "覆盖率报告: coverage/lcov.info"
	@echo "使用 genhtml coverage/lcov.info -o coverage/html 生成 HTML 报告"

test-name: ## 运行指定名称的测试（用法: make test-name NAME="关键字"）
	flutter test --name="$(NAME)"

# ─── 运行 ───────────────────────────────────────────────────
run: ## 启动应用（macOS）
	flutter run -d macos

run-release: ## 启动应用（release 模式）
	flutter run -d macos --release

# ─── 构建 ───────────────────────────────────────────────────
build: ## 构建 macOS 生产版本
	flutter build macos --release

# ─── 清理 ───────────────────────────────────────────────────
clean: ## 清理构建产物
	flutter clean
	flutter pub get
