import 'package:flutter/material.dart';
import 'package:tao996/tao996.dart';

/// 加载指示器。
class MyLoading extends StatelessWidget {
  const MyLoading({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

/// 放在 AppBar bottom 中的加载进度条。
PreferredSizeWidget? myAppBarLoading(RxBool isLoading) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(2),
    child: RxBoolBuilder(
      rx: isLoading,
      builder: (_, loading) =>
          loading ? const LinearProgressIndicator() : const SizedBox(height: 2),
    ),
  );
}
