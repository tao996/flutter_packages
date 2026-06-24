/**
 * 页面控制器组件规范
 *
 * 覆盖 SmartRefresher / Pagination / EasyRefresh / Network / SearchInput / QRCode / CustomTabBar。
 */

// ============================================================
// MySmartRefresher — 下拉刷新 + 上拉加载
// ============================================================
/**
 * 智能刷新控制器基类。
 * 替代旧的 MySmartRefresherController<T>（移除 GetX 依赖）。
 */
declare class SmartRefresherController<T> {
  delegate: ListDelegate<T>;
  pageIndex: number;
  pageSize: number;
  hasMore: RxBool;
  items: RxList<T>;
  isRequesting: RxBool;
  isIniting: RxBool;
  refreshController: any; // RefreshController

  constructor(config?: { autoLoad?: boolean; pageSize?: number; delegate?: ListDelegate<T> });

  /** 加载数据 — 子类必须实现 */
  loadData(config: { isRefresh: boolean }): Promise<T[] | null>;

  /** 下拉刷新 */
  onRefresh(): Promise<void>;

  /** 上拉加载更多 */
  onLoadMore(): Promise<void>;

  /** 搜索 */
  onReSearch(): Promise<void>;

  /** 重置页码 */
  pageIndexReset(): void;

  /** 绑定搜索 */
  bindSearch(text: string): void;

  /** 释放资源 */
  dispose(): void;
}

/**
 * 列表数据委托（响应式）。
 */
declare class ListDelegate<T> {
  rxItems: RxList<T>;
  rxTotal: RxInt;

  sync(config: { index: number; entity?: T; unshift?: boolean }): Promise<void>;
}

/**
 * 模型操作委托（带数据库同步）。
 */
declare class ModelDelegate<T> extends ListDelegate<T> {
  insert(entity: T, config?: { syncDb?: boolean; showMessage?: boolean }): Promise<void>;
  update(entity: T, config?: { index?: number; syncDb?: boolean }): Promise<void>;
  remoteAt(config: { index: number; syncDb?: boolean; confirm?: boolean }): Promise<number>;
}

// ============================================================
// SmartRefresher Widget
// ============================================================
declare class MySmartRefresher {
  /** 通用列表视图 */
  static obxListView<T>(
    controller: SmartRefresherController<T>,
    props: {
      itemBuilder: (context: any, index: number) => any;
      itemCount: number;
      canLoadMore?: boolean;
      empty?: any;
      separatorBuilder?: (context: any, index: number) => any;
      padding?: any;
      key?: any;
    },
  ): any;
}

// ============================================================
// MyPagination — 分页组件（PC 端翻页按钮）
// ============================================================
declare class MyPaginationWidget {
  constructor(
    controller: MyPaginationController,
    props?: { showTotalPages?: boolean; key?: any },
  );
}

declare class MyPaginationController<T> {
  items: RxList<T>;
  total: RxInt;
  pageIndex: RxInt;
  pageSize: RxInt;
  loadItemsData(): Promise<void>;
  bindPageIndexChange(newPage: number): Promise<void>;
}

// ============================================================
// MyEasyRefresh — 简单下拉刷新
// ============================================================
declare class EasyRefreshController {
  scrollController: any;
  hasMore: RxBool;
  onRefresh(): Promise<void>;
  onLoadMore(): Promise<void>;
}

declare class EasyRefresh {
  static listView(
    controller: EasyRefreshController,
    props: {
      itemBuilder: (context: any, index: number) => any;
      itemCount: number;
      separatorBuilder?: (context: any, index: number) => any;
      padding?: any;
      key?: any;
    },
  ): any;
}

// ============================================================
// MyNetworkController — 网络状态
// ============================================================
declare class NetworkController {
  results: RxList<any>;

  onInit(): void;
  dispose(): void;
}

// ============================================================
// SearchInput — 搜索框
// ============================================================
declare class SearchInput {
  constructor(props: {
    controller: any;
    hintText?: string;
    onChanged?: (text: string) => void;
    onSubmitted?: (text: string) => void;
    key?: any;
  });
}

// ============================================================
// QRCodeView — 二维码扫描
// ============================================================
declare class QRCodeView {
  constructor(props: { key?: any });
}

// ============================================================
// MyNetworkWidget — 网络状态 Widget
// ============================================================
declare class MyNetworkAwareWidget {
  constructor(props: {
    child: any;
    offlineChild?: any;
    key?: any;
  });
}
