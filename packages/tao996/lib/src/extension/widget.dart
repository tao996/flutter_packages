import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  Widget padding({double horizontal = 16, double vertical = 8}) => Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
    child: this,
  );

  Widget unfocusOnTap() => GestureDetector(
    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    child: this,
  );
  // 点击事件
  Widget onTap({VoidCallback? onTap}) => InkWell(onTap: onTap, child: this);
}
