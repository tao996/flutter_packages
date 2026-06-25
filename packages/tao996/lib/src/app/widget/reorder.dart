import 'package:flutter/material.dart';
import 'package:tao996/tao996.dart';

/// 拖拽排序列表。
class MyReorder<T> extends StatelessWidget {
  final RxList<T> items;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget? emptyWidget;
  final void Function(int oldIndex, int newIndex)? onReorder;

  const MyReorder(
    this.items, {
    super.key,
    required this.itemBuilder,
    this.onReorder,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    return RxBuilder<List<T>>(
      rx: items,
      builder: (_, itemList) {
        if (itemList.isEmpty) {
          return emptyWidget ?? MyWidgetHelper.empty();
        }
        return ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemList.length,
          onReorderItem: onReorder ?? _onReorder,
          buildDefaultDragHandles: false,
          proxyDecorator: (child, index, animation) => Material(
            elevation: 6,
            color: Colors.transparent,
            shadowColor: Colors.black,
            child: child,
          ),
          itemBuilder: itemBuilder,
        );
      },
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final item = items.value.removeAt(oldIndex);
    items.value = [
      ...items.value.take(newIndex),
      item,
      ...items.value.skip(newIndex),
    ];
  }
}

Widget myReorderDragHandleIcon(int index) {
  return ReorderableDragStartListener(
    index: index,
    child: const Icon(Icons.drag_handle),
  );
}
