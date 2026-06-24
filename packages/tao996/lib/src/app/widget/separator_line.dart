import 'package:flutter/material.dart';

/// 分隔线组件 - 简单的水平分隔线。
///
/// 使用方式:
/// ```dart
/// MySeparatorLine()
/// ```
class MySeparatorLine extends StatelessWidget {
  const MySeparatorLine({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      color: Color(0xFFEEEEEE),
      thickness: 1.0,
      indent: 16.0,
      endIndent: 60.0,
    );
  }
}
