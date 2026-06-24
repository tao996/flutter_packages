import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tao996/tao996.dart';

/// 智能刷新控制器 — 下拉刷新 + 上拉加载更多。
///
/// 替代旧的 MySmartRefresherController（移除 GetxController 依赖）。
abstract class SmartRefresherController<T> {
  /// 当前页码，从 1 开始。
  int pageIndex = 1;

  /// 每页数量。
  int pageSize = 15;

  /// 是否有更多数据。
  final RxBool hasMore = RxBool(true);

  /// 数据列表。
  final RxList<T> items = RxList<T>();

  /// 是否正在请求数据。
  final RxBool isRequesting = RxBool(false);

  /// 是否正在初始化。
  final RxBool isIniting = RxBool(false);

  /// 刷新控制器（来自 pull_to_refresh 包）。
  late RefreshController refreshController;

  SmartRefresherController({bool autoLoad = false, this.pageSize = 15}) {
    refreshController = RefreshController(initialRefresh: autoLoad);
  }

  /// 加载数据 — 子类必须实现。
  /// [isRefresh] 是否为刷新（重置页码）。
  Future<List<T>?> loadData({required bool isRefresh});

  /// 初始化数据。
  Future<void> initData() async {
    isIniting.value = true;
    try {
      await smartRefresh(isRefresh: true);
    } finally {
      isIniting.value = false;
    }
  }

  /// 核心刷新逻辑。
  Future<void> smartRefresh({bool isRefresh = false}) async {
    if (isRefresh) {
      pageIndex = 1;
      hasMore.value = true;
    }
    if (!hasMore.value) return;

    final newItems = await loadData(isRefresh: isRefresh);
    if (newItems == null || newItems.isEmpty) {
      hasMore.value = false;
      if (isRefresh) {
        refreshController.refreshCompleted();
        items.clear();
      } else {
        refreshController.loadNoData();
      }
    } else {
      if (isRefresh) {
        items.replaceAll(newItems);
        refreshController.refreshCompleted();
      } else {
        items.addAll(newItems);
        refreshController.loadComplete();
      }
      if (newItems.length < pageSize) {
        hasMore.value = false;
      }
      pageIndex++;
    }
  }

  /// 下拉刷新。
  Future<void> onRefresh() async {
    isRequesting.value = true;
    try {
      await smartRefresh(isRefresh: true);
    } finally {
      isRequesting.value = false;
    }
  }

  /// 上拉加载更多。
  Future<void> onLoadMore() async {
    isRequesting.value = true;
    try {
      await smartRefresh();
    } finally {
      isRequesting.value = false;
    }
  }

  /// 搜索/重新查询。
  Future<void> onReSearch() async {
    isRequesting.value = true;
    try {
      await smartRefresh(isRefresh: true);
    } finally {
      isRequesting.value = false;
    }
  }

  /// 重置页码。
  void pageIndexReset() {
    pageIndex = 1;
  }

  /// 释放资源。
  void dispose() {
    refreshController.dispose();
  }
}

/// 智能刷新 Widget。
class MySmartRefresher {
  MySmartRefresher._();

  /// 通用的可刷新列表视图。
  static Widget obxListView<T>(
    SmartRefresherController<T> controller, {
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    bool canLoadMore = true,
    Widget? empty,
    Widget Function(BuildContext, int)? separatorBuilder,
    EdgeInsetsGeometry? padding,
  }) {
    return RxBoolBuilder(
      rx: controller.isIniting,
      builder: (_, loading) {
        if (loading) return const Center(child: CircularProgressIndicator());
        return SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: canLoadMore && controller.hasMore.value,
          onRefresh: controller.onRefresh,
          onLoading: controller.onLoadMore,
          child: controller.items.value.isEmpty
              ? (empty ?? const SizedBox())
              : ListView.separated(
                  itemCount: itemCount,
                  itemBuilder: itemBuilder,
                  separatorBuilder:
                      separatorBuilder ?? (_, _) => const SizedBox(height: 4),
                  padding: padding ?? const EdgeInsets.all(4),
                ),
        );
      },
    );
  }
}
