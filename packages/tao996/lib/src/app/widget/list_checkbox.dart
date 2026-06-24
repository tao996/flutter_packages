import 'package:flutter/material.dart';
import 'package:tao996/tao996.dart';

/// 列表多选组件 - 支持泛型的复选框列表。
///
/// 使用方式:
/// ```dart
/// ListCheckbox<String>(
///   items: [
///     KV(label: 'Apple', value: 'apple'),
///     KV(label: 'Banana', value: 'banana'),
///   ],
///   values: ['apple'],
///   onSelectionChanged: (selected) {
///     print('Selected: $selected');
///   },
/// )
/// ```
class ListCheckbox<T> extends StatefulWidget {
  /// 待显示的列表
  final List<KV<T>> items;

  /// 初始选中的值列表
  final List<T>? values;

  /// 当任何复选框的选中状态发生改变时调用的回调函数
  final ValueChanged<List<T>>? onSelectionChanged;

  /// 是否使用紧凑模式
  final bool dense;

  const ListCheckbox({
    super.key,
    required this.items,
    this.values,
    this.onSelectionChanged,
    this.dense = false,
  });

  @override
  State<ListCheckbox> createState() => _ListCheckboxState<T>();
}

class _ListCheckItem<T> {
  final KV<T> item;
  bool selected;

  _ListCheckItem({required this.item, required this.selected});
}

class _ListCheckboxState<T> extends State<ListCheckbox<T>> {
  late List<_ListCheckItem<T>> _listWithSelectionState;

  @override
  void initState() {
    super.initState();
    _initializeList();
  }

  void _initializeList() {
    _listWithSelectionState = widget.items
        .map(
          (item) => _ListCheckItem<T>(
            item: item,
            selected:
                widget.values != null && widget.values!.contains(item.value),
          ),
        )
        .toList();
  }

  @override
  void didUpdateWidget(covariant ListCheckbox<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items || widget.values != oldWidget.values) {
      _initializeList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _listWithSelectionState.length,
      itemBuilder: (context, index) {
        final item = _listWithSelectionState[index];

        return CheckboxListTile(
          dense: widget.dense,
          value: item.selected,
          title: Text(item.item.label),
          onChanged: (bool? newValue) {
            setState(() {
              item.selected = newValue ?? false;
            });

            widget.onSelectionChanged?.call(
              _listWithSelectionState
                  .where((item) => item.selected)
                  .map((item) => item.item.value)
                  .toList(),
            );
          },
        );
      },
    );
  }
}
