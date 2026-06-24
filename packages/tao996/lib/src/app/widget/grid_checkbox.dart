import 'package:flutter/material.dart';

/// 网格多选组件 - 网格布局的复选框按钮组。
///
/// 使用方式:
/// ```dart
/// GridCheckbox(
///   items: ['Apple', 'Banana', 'Cherry'],
///   values: ['Apple'],
///   crossAxisCount: 3,
///   onSelectionChanged: (selected) {
///     print('Selected: $selected');
///   },
/// )
/// ```
class GridCheckbox extends StatefulWidget {
  /// 所有的可选项列表
  final List<String> items;

  /// 初始选中的项列表
  final List<String>? values;

  /// 选中状态改变时调用的回调函数
  final ValueChanged<List<String>> onSelectionChanged;

  /// 列数，用于控制布局，默认为 3
  final int crossAxisCount;

  /// 水平内边距
  final double horizontal;

  const GridCheckbox({
    super.key,
    required this.items,
    required this.onSelectionChanged,
    this.values,
    this.crossAxisCount = 3,
    this.horizontal = 18,
  });

  @override
  State<GridCheckbox> createState() => _GridCheckboxState();
}

class _GridCheckboxState extends State<GridCheckbox> {
  final Set<String> _selectedNames = {};

  @override
  void initState() {
    super.initState();
    if (widget.values != null) {
      _selectedNames.addAll(widget.values!);
    }
  }

  @override
  void didUpdateWidget(covariant GridCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.values != oldWidget.values) {
      _selectedNames.clear();
      if (widget.values != null) {
        _selectedNames.addAll(widget.values!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: widget.horizontal),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 2.5,
      ),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final name = widget.items[index];
        final isSelected = _selectedNames.contains(name);

        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedNames.remove(name);
              } else {
                _selectedNames.add(name);
              }
            });
            widget.onSelectionChanged(_selectedNames.toList());
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.primary : colorScheme.surface,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withAlpha(125),
                width: isSelected ? 2.0 : 1.0,
              ),
            ),
            child: Text(
              name,
              style: TextStyle(
                color:
                    isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
