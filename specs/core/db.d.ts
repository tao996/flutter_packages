/**
 * 数据库层规范 — DB Layer
 *
 * 数据模型基类、查询构建器、存储库模式、迁移框架。
 *
 * 生成目标:
 *   Dart → class IModel, class QueryBuilder, class Repository<T>, class Migrator
 *   ArkTS → class IModel, class QueryBuilder, class Repository<T>, class Migrator
 *   Kotlin → open class IModel, class QueryBuilder, class Repository<T>, class Migrator
 *   Swift → class IModel, struct QueryBuilder, class Repository<T>, class Migrator
 */

// ============================================================
// 基础 JSON 类型
// ============================================================

/** JSON 基本类型 */
type JsonPrimitive = string | number | boolean | null;
/** JSON 值（递归） */
type JsonValue = JsonPrimitive | JsonObject | JsonValue[];
/** JSON 对象 */
interface JsonObject {
  [key: string]: JsonValue;
}

// ============================================================
// 分页 DTO
// ============================================================

/** 分页请求参数 */
interface PaginationRequest {
  pageIndex: number;
  pageSize: number;
}

/** 分页查询结果 */
interface PaginationResult<T> {
  items: T[];
  total: number;
  pageIndex: number;
  pageSize: number;
  get hasMore(): boolean;
}

// ============================================================
// 数据模型基类
// ============================================================

/**
 * 数据模型基类。
 * 所有数据库模型的基类，提供 id / createdAt / updatedAt / deletedAt。
 */
declare class IModel {
  id: number;
  createdAt: string;
  updatedAt: string;
  deletedAt: string | null;

  constructor(config?: { id?: number; createdAt?: string; updatedAt?: string; deletedAt?: string });

  /** 从 JSON Map 创建 */
  static fromJson(json: JsonObject): IModel;

  /** 转为 JSON Map */
  toJson(): JsonObject;

  /** 从另一个模型复制基础字段 */
  copyBaseDataFrom(other: IModel | null): void;

  /** 是否已软删除 */
  get isDeleted(): boolean;

  /** 标记为已删除 */
  markDeleted(): void;
}

// ============================================================
// SQL 查询构建器
// ============================================================

/**
 * SQL 查询构建器。
 * 构建 WHERE / ORDER BY / LIMIT / OFFSET 子句。
 */
declare class QueryBuilder {
  /** 添加 WHERE 条件 */
  where(condition: string, arg?: any): QueryBuilder;

  /** 添加可选条件 — 只有 condition 非空时才添加 */
  whereIf(condition: string, arg?: any): QueryBuilder;

  /** 设置排序 */
  orderBy(order: string): QueryBuilder;

  /** 设置返回行数上限 */
  limit(limit: number): QueryBuilder;

  /** 设置偏移量 */
  offset(offset: number): QueryBuilder;

  /** 构建完整的 WHERE + ORDER BY + LIMIT + OFFSET 子句 */
  build(): string;

  /** WHERE 子句的参数值列表 */
  get whereArgs(): any[];

  /** 重置构建器 */
  reset(): void;
}

// ============================================================
// 存储库模式
// ============================================================

/**
 * 数据库存储库 — 泛型 CRUD + 分页。
 * 替代旧的 ModelHelper + ModelAction + ModelDelegate 三层。
 */
declare class Repository<T extends IModel> {
  constructor(config: {
    db: IDatabaseService;
    tableName: string;
    fromJson: (json: JsonObject) => T;
    toJson: (item: T) => JsonObject;
  });

  /** 按 ID 查询 */
  getById(id: number): Promise<T | null>;

  /** 按 ID 列表查询 */
  getByIds(ids: number[]): Promise<T[]>;

  /** 条件查询 */
  query(qb?: QueryBuilder): Promise<T[]>;

  /** 分页查询 */
  queryPaginated(config: { page?: number; pageSize?: number; qb?: QueryBuilder }): Promise<PaginatedResult<T>>;

  /** 插入记录 */
  insert(record: T): Promise<number>;

  /** 更新记录 */
  update(record: T): Promise<number>;

  /** 软删除 */
  delete(id: number): Promise<number>;

  /** 物理删除 */
  hardDelete(id: number): Promise<number>;
}

/** 分页查询结果 */
declare class PaginatedResult<T extends IModel> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
  get totalPages(): number;
  get hasMore(): boolean;
}

/** 数据库服务接口 */
declare interface IDatabaseService {
  query(sql: string, args?: unknown[]): Promise<JsonObject[]>;
  execute(sql: string, args?: unknown[]): Promise<number>;
  executeBatch(statements: SqlStatement[]): Promise<void>;
  close(): Promise<void>;
}

declare class SqlStatement {
  sql: string;
  args?: unknown[];
  constructor(sql: string, args?: unknown[]);
}

// ============================================================
// 数据库迁移框架
// ============================================================

/** 数据库迁移模块接口 */
declare interface Migration {
  get id(): string;
  get version(): number;
  onCreate(db: IDatabaseService): void;
  onUpgrade(db: IDatabaseService, installVersion: number): void;
}

/** 迁移执行器 */
declare class Migrator {
  constructor(db: IDatabaseService, modules: Migration[], config?: { targetVersion?: number });
  execute(): Promise<void>;
}
