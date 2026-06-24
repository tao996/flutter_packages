import 'package:flutter/material.dart';
import 'package:tao996/tao996.dart';

/// 简单的分页控制器，通过「上一页」「下一页」按钮翻页。
abstract class MyPaginationController<T> {
  final RxList<T> items = RxList<T>();
  final RxInt total = RxInt(0);
  final RxInt pageIndex = RxInt(1);
  final RxInt pageSize = RxInt(20);

  /// 加载数据 — 子类必须实现。
  Future<void> loadItemsData();

  /// 修改页码并加载数据。
  void bindPageIndexChange(int newPage) async {
    pageIndex.value = newPage;
    await loadItemsData();
  }
}

/// PC 端分页组件。
class MyPaginationWidget extends StatelessWidget {
  final MyPaginationController controller;
  final bool showTotalPages;

  const MyPaginationWidget(
    this.controller, {
    super.key,
    this.showTotalPages = true,
  });

  @override
  Widget build(BuildContext context) {
    return RxBuilder<int>(
      rx: controller.pageIndex,
      builder: (_, pageIdx) {
        final totalPages = (controller.total.value / controller.pageSize.value)
            .ceil();
        return Row(
          mainAxisAlignment: showTotalPages
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            if (showTotalPages)
              Text(
                '显示 ${(pageIdx - 1) * controller.pageSize.value + 1}'
                '-${(pageIdx * controller.pageSize.value).clamp(0, controller.total.value)} 条，'
                '共 ${controller.total.value} 条',
              ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: pageIdx > 1
                      ? () => controller.bindPageIndexChange(pageIdx - 1)
                      : null,
                ),
                Text('第 $pageIdx 页 / 共 $totalPages 页'),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: pageIdx < totalPages
                      ? () => controller.bindPageIndexChange(pageIdx + 1)
                      : null,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
