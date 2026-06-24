import 'package:flutter/material.dart';
import 'package:tao996/tao996.dart';

/// 简单的下拉刷新控制器。
abstract class EasyRefreshController {
  final ScrollController scrollController = ScrollController();
  final RxBool hasMore = RxBool(true);

  /// 下拉刷新。
  Future<void> onRefresh();

  /// 上拉加载更多。
  Future<void> onLoadMore();

  /// 释放资源。
  void dispose() {
    scrollController.dispose();
  }
}

/// 简易下拉刷新组件（基于 RefreshIndicator）。
class EasyRefresh {
  EasyRefresh._();

  /// 可下拉刷新的列表。
  static Widget listView(
    EasyRefreshController controller, {
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    Widget Function(BuildContext, int)? separatorBuilder,
    EdgeInsetsGeometry? padding,
  }) {
    return RefreshIndicator(
      onRefresh: controller.onRefresh,
      child: ListView.separated(
        controller: controller.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder:
            separatorBuilder ?? (_, _) => const SizedBox(height: 4),
        itemCount: itemCount,
        padding: padding ?? const EdgeInsets.all(4),
        itemBuilder: itemBuilder,
      ),
    );
  }
}
