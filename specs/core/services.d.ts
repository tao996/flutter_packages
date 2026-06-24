/**
 * 核心服务接口 — Core Service Interfaces
 *
 * 所有服务接口定义在 core 层，实现交给具体平台。
 *
 * 生成目标:
 *   Dart → abstract class IXxxService { ... }
 *   ArkTS → interface IXxxService { ... }
 *   Kotlin → interface IXxxService { ... }
 *   Swift → protocol IXxxService { ... }
 */

// ──────────────────────────────────────────
// 数据库
// ──────────────────────────────────────────

/** SQL 语句 */
declare interface SqlStatement {
  sql: string;
  args?: any[];
}

/** 数据库服务 */
declare interface IDatabaseService {
}

// ──────────────────────────────────────────
// 设置
// ──────────────────────────────────────────

/** 应用设置服务 */
declare interface ISettingsService {
  language: string;
  themeMode: number;
  textScaleFactor: number;
  useLowDataMode: boolean;
  proxyAddress: string;
  proxyPort: string;
  useProxy: boolean;
  transition: string;
}

// ──────────────────────────────────────────
// 日志 / 调试
// ──────────────────────────────────────────

/** 日志级别 */
type LogLevel = 'debug' | 'info' | 'warn' | 'error';

/** 日志服务 */
declare interface ILogService {
  log(level: LogLevel, message: string, args?: unknown): void;
  debug(message: string, args?: unknown): void;
  info(message: string, args?: unknown): void;
  warn(message: string, args?: unknown): void;
  error(message: string, args?: unknown): void;
}

/** 调试服务（用于开发阶段） */
declare interface IDebugService {
  d(message: string, args?: unknown): void;
  exception(error: unknown, stackTrace: unknown, errorMessage?: string): void;
}

// ──────────────────────────────────────────
// 网络
// ──────────────────────────────────────────

/** 网络状态 */
type NetworkState = 'wifi' | 'mobile' | 'ethernet' | 'none';

/** 网络服务 */
declare interface INetworkService {
  get state(): RxList<NetworkState>;
  get isNoNetwork(): boolean;
  get isMobileNetwork(): boolean;
  get isWifi(): boolean;
  onConnectivityChanged(callback: (states: NetworkState[]) => void): void;
}

// ──────────────────────────────────────────
// 文件/路径
// ──────────────────────────────────────────

/** 路径服务 */
declare interface IPathService {
  homeDir(): Promise<string>;
  join(...segments: string[]): string;
  basename(path: string): string;
  dirname(path: string): string;
  fileExists(path: string): Promise<boolean>;
}

// ──────────────────────────────────────────
// 国际化
// ──────────────────────────────────────────

/** 翻译服务 */
declare interface ITranslationService {
  translate(key: string, params?: Record<string, string>): string;
  get supportedLocales(): string[];
  get currentLocale(): string;
  setLocale(locale: string): void;
}
