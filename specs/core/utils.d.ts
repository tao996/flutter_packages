/**
 * 纯工具函数接口 — Utility Interfaces
 *
 * 纯 Dart / ArkTS / Kotlin / Swift 通用工具函数。
 * 不依赖任何框架。
 */
// ============================================================
// namespace: ArrayUtils
// ============================================================
declare namespace ArrayUtils {
  function intersection<T>(a: T[], b: T[]): T[];
  function union<T>(a: T[], b: T[]): T[];
  function difference<T>(a: T[], b: T[]): T[];
  function unique<T>(list: T[]): T[];
  function flatten<T>(list: T[][]): T[];
  function deepCompare<T>(
    a: T[], b: T[],
    compare: (a: T, b: T) => boolean,
    insertion: (items: T[]) => void,
    deletion: (items: T[]) => void,
    update: (items: T[]) => void,
  ): void;
}

// 兼容原有 class 声明
declare class ArrayUtil {
  static intersection<T>(a: T[], b: T[]): T[];
  static union<T>(a: T[], b: T[]): T[];
  static difference<T>(a: T[], b: T[]): T[];
  static unique<T>(list: T[]): T[];
  static flatten<T>(list: T[][]): T[];
  static deepCompare<T>(
    a: T[], b: T[],
    compare: (a: T, b: T) => boolean,
    insertion: (items: T[]) => void,
    deletion: (items: T[]) => void,
    update: (items: T[]) => void,
  ): void;
}

// ============================================================
// 加密工具
// ============================================================
declare class CryptoUtil {
  static md5Text(input: string): string;
  static md5Bytes(data: Uint8Array): string;
  static sha256Text(input: string): string;
  static sha256Bytes(data: Uint8Array): string;
}

// ============================================================
// 文件路径工具
// ============================================================
declare class FilepathUtil {
  static join(...segments: string[]): string;
  static basename(path: string): string;
  static dirname(path: string): string;
  static extension(path: string): string;
  static isAbsolute(path: string): boolean;
  static homeDir(): string;
}

// ============================================================
// 数字工具
// ============================================================
declare class NumberUtil {
  static fenToYuan(num: number, fractionDigits?: number, emptyText?: boolean): string;
  static yuanToFen(money: string): number;
  static parseInt(value: string): number;
  static parseDouble(value: string): number;
  static formatNumber(data: any): string;
  static sum(list: number[]): number;
}

// ============================================================
// 数据转换工具
// ============================================================
declare class DataUtil {
  static getBool(v: any, defaultValue?: boolean): boolean;
  static getInt(v: any, defaultValue?: number): number;
  static getDouble(v: any, defaultValue?: number): number;
  static getString(v: any, defaultValue?: string): string;
  static jsonString(data: any): string;
  static copy(data: any): any;
  static hasMatch(data: string, pattern: string): boolean;
}

// ============================================================
// 日期时间工具
// ============================================================
declare class DatetimeUtil {
  static format(date: Date, pattern: string): string;
  static parse(str: string, formatPattern?: string): Date | null;
  static now(): Date;
  static today(): Date;
  static daysBetween(a: Date, b: Date): number;
}

// ============================================================
// 文本工具
// ============================================================
declare class TextUtil {
  static base64Encode(input: string): string;
  static base64Decode(input: string): string;
  static truncate(text: string, maxLength: number, suffix?: string): string;
  static capitalize(text: string): string;
  static capitalizeAll(text: string): string;
  static toCamelCase(text: string): string;
  static toSnakeCase(text: string): string;
  static reverse(text: string): string;
  static isBlank(text: string | null): boolean;
  static isNotBlank(text: string | null): boolean;
  static random(length: number, chars?: string): string;
  static padZero(value: number, length: number): string;
}

// ============================================================
// 函数工具
// ============================================================
declare class FnUtil {
  static debounce(callback: () => void, milliseconds?: number): DebounceFn;
  static throttle(callback: () => void, milliseconds?: number): () => void;
  static idle(callback: () => void): void;
  static delay(milliseconds: number, callback?: () => void): Promise<void>;
  static identity<T>(value: T): T;
  static compose<T>(f: (x: T) => T, g: (x: T) => T): (x: T) => T;
}
declare class DebounceFn {
  call(): void;
  cancel(): void;
}

// ============================================================
// 堆栈工具
// ============================================================
declare class StackUtil {
  static format(trace: string, filterNames?: string[], maxLines?: number): string;
  static firstFrame(trace: string): string;
  static dprint(message: any, filterNames?: string[], showStack?: boolean): void;
}

// ============================================================
// 类型转换工具
// ============================================================
declare class CastUtil {
  static asString(value: any, defaultValue?: string): string;
  static asInt(value: any, defaultValue?: number): number;
  static asDouble(value: any, defaultValue?: number): number;
  static asBool(value: any, defaultValue?: boolean): boolean;
  static asList<T>(value: any, castItem: (item: any) => T): T[];
  static asListStrict<T>(value: any): T[];
  static asListFlat<T>(value: any): T[];
  static asMap(value: any, defaultValue?: Record<string, any>): Record<string, any>;
  static tryCast<T>(value: any): T | null;
  static forceCast<T>(value: any, defaultValue: T): T;
}

// ============================================================
// JSON 工具
// ============================================================
declare class JsonUtil {
  static tryParse(json: string): any;
  static tryParseMap(json: string): Record<string, any> | null;
  static prettyPrint(data: any): string;
  static deepMerge(target: Record<string, any>, source: Record<string, any>): Record<string, any>;
  static getByPath(data: Record<string, any>, path: string, defaultValue?: any): any;
  static setByPath(data: Record<string, any>, path: string, value: any): void;
  static compact(data: Record<string, any>): Record<string, any>;
}

// ============================================================
// JSON Schema 校验
// ============================================================
type SchemaFieldType = 'string' | 'int' | 'double' | 'bool' | 'list' | 'map';

declare class JsonField {
  constructor(config: { type: SchemaFieldType; required?: boolean; pattern?: string; min?: number; max?: number });
}
declare class JsonSchema {
  constructor(fields: Record<string, JsonField>);
  validate(data: Record<string, any>): SchemaResult;
}
declare class SchemaResult {
  get isValid(): boolean;
  get isInvalid(): boolean;
  get errors(): string[];
}

// ============================================================
// Result 类型
// ============================================================
declare class Result<T, E> {
  static ok<T, E>(value: T): Result<T, E>;
  static err<T, E>(error: E): Result<T, E>;
  static tryCatch<T, E>(block: () => T, onError: (e: any) => E): Result<T, E>;
  get isOk(): boolean;
  get isErr(): boolean;
  get value(): T;
  get error(): E;
  match<R>(handlers: { ok: (v: T) => R; err: (e: E) => R }): R;
  map<R>(transform: (v: T) => R): Result<R, E>;
  then<R>(next: (v: T) => Result<R, E>): Result<R, E>;
  orDefault(defaultValue: T): T;
  orElse(fallback: (e: E) => T): T;
  onOk(callback: (v: T) => void): Result<T, E>;
  onErr(callback: (e: E) => void): Result<T, E>;
}

// ============================================================
// 数据校验器
// ============================================================
declare class Validator {
  required(value: string | null, fieldName: string): Validator;
  email(value: string | null, fieldName: string): Validator;
  phone(value: string | null, fieldName: string): Validator;
  minLength(value: string | null, min: number, fieldName: string): Validator;
  maxLength(value: string | null, max: number, fieldName: string): Validator;
  range(value: number | null, min: number, max: number, fieldName: string): Validator;
  matches(value: string | null, regex: RegExp, message: string): Validator;
  check(condition: boolean, message: string): Validator;
  validate(): ValidationResult;
}
declare class ValidationResult {
  get isValid(): boolean;
  get isInvalid(): boolean;
  get errors(): string[];
}

// ============================================================
// 异常类
// ============================================================
declare class AppException extends Error {
  constructor(message: string, cause?: any);
}
declare class AppEasyException extends Error {
  constructor(message: string);
}
declare class NetworkException extends AppException {
  constructor(message: string, statusCode?: number, cause?: any);
}
declare class DatabaseException extends AppException {
  constructor(message: string, cause?: any);
}

// ============================================================
// KV 类型 — Key-Value Pair
// ============================================================
/**
 * 键值对类型，用于表单选项、下拉列表等场景。
 *
 * 泛型 T 表示值的类型，label 始终为 string。
 *
 * 实现位置：tao996_core/lib/src/types/kv.dart
 */
declare class KV<T> {
  label: string;
  value: T;

  constructor(props: { label: string; value: T });
  toString(): string;
}

/**
 * 从枚举映射创建 KV 列表。
 *
 * @param maps 枚举值到标签的映射
 * @returns KV 列表
 *
 * @example
 * ```typescript
 * enum Gender { Male, Female }
 * const list = kvCreateList({ [Gender.Male]: '男', [Gender.Female]: '女' })
 * ```
 */
declare function kvCreateList<T extends Enum>(maps: Map<T, string>): KV<T>[];

/**
 * 查询列表中指定值的枚举键。
 *
 * @param kvs 键值对列表
 * @param name 枚举属性的字符串（enum.name）
 * @param firstIfNotFound 找不到时是否返回第一个（默认 true）
 * @returns 枚举值
 * @throws 如果 firstIfNotFound=false 且找不到，抛出异常
 */
declare function kvGetValue<T extends Enum>(
  kvs: KV<T>[],
  name: string | null,
  firstIfNotFound?: boolean
): T;

/**
 * 尝试查询列表中指定值的枚举键，找不到返回 null。
 *
 * @param kvs 键值对列表
 * @param name 枚举属性的字符串
 * @returns 枚举值或 null
 */
declare function kvTryGetValue<T extends Enum>(kvs: KV<T>[], name: string | null): T | null;

/**
 * 获取枚举值对应的标签。
 *
 * @param kvs 键值对列表
 * @param value 枚举值
 * @param defaultLabel 找不到时返回的默认标签
 * @returns 标签字符串
 */
declare function kvGetLabel<T extends Enum>(
  kvs: KV<T>[],
  value: T,
  defaultLabel?: string
): string;

/**
 * KV 列表扩展方法（仅枚举类型）
 */
declare interface KVList<T extends Enum> {
  /** 根据 name 获取枚举值 */
  getValue(name: string | null): T | null;
  /** 提取所有 label */
  labels(): string[];
  /** 提取所有 value */
  values(): T[];
}
