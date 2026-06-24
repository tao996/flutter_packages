import 'package:flutter/material.dart';

/// 表格列配置。
class MyHeaderColumn {
  /// 自定义组件（优先使用）
  Widget? label;

  /// 显示的文字
  String text;

  /// 固定的宽度
  double? width;

  /// 占满剩余空间的比例
  double flex;

  MyHeaderColumn({this.label, this.text = '', this.width, this.flex = 1});
}

/// 表格组件 - DataTable 的封装。
///
/// 使用方式:
/// ```dart
/// MyTable(
///   headers: [
///     DataColumn(label: Text('Name')),
///     DataColumn(label: Text('Age')),
///   ],
///   rows: [
///     DataRow(cells: [DataCell(Text('Alice')), DataCell(Text('25'))]),
///     DataRow(cells: [DataCell(Text('Bob')), DataCell(Text('30'))]),
///   ],
/// )
/// ```
class MyTable extends StatelessWidget {
  final List<DataColumn> headers;

  /// 数据行，如果需要索引可以使用 `List.generate(data.length, (index) {...})`
  final List<DataRow> rows;
  final double dataRowHeight;
  final double? dataRowMaxHeight;
  final double? dataRowMinHeight;

  const MyTable({
    required this.headers,
    required this.rows,
    this.dataRowHeight = 60,
    this.dataRowMaxHeight,
    this.dataRowMinHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Card(
              shape: const RoundedRectangleBorder(),
              elevation: 1,
              child: DataTable(
                dataRowMaxHeight: dataRowMaxHeight ?? dataRowHeight,
                dataRowMinHeight: dataRowMinHeight ?? dataRowHeight,
                columnSpacing: 24,
                dividerThickness: 1,
                headingRowColor: WidgetStateProperty.all(Colors.transparent),
                dataRowColor: WidgetStateProperty.all(Colors.transparent),
                headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                columns: headers,
                rows: rows,
              ),
            ),
          ),
        );
      },
    );
  }
}
