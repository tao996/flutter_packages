import 'package:flutter/material.dart';
import 'package:tao996/tao996.dart';

/// 加载对话框工具类。
class MyLoadingDialog {
  MyLoadingDialog._();

  static bool _isShowing = false;

  /// 显示加载对话框。返回一个关闭函数。
  static Future<void Function()> show(
    BuildContext context, {
    String? message,
    bool barrierDismissible = false,
    Duration? timeout,
  }) async {
    if (_isShowing) return () {};

    _isShowing = true;
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => PopScope(
        canPop: barrierDismissible,
        child: AlertDialog(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(message ?? i18n('loading', '加载中...')),
            ],
          ),
        ),
      ),
    ).then((_) => _isShowing = false);

    if (timeout != null) {
      Future.delayed(timeout, () {
        if (_isShowing && context.mounted) {
          Navigator.of(context, rootNavigator: true).maybePop();
        }
      });
    }

    void close() {
      if (_isShowing && context.mounted) {
        _isShowing = false;
        Navigator.of(context, rootNavigator: true).maybePop();
      }
    }

    return close;
  }

  /// 在异步操作完成后自动关闭加载框。
  static Future<T> wrap<T>(
    BuildContext context,
    Future<T> Function() operation, {
    String? message,
    Duration? timeout,
  }) async {
    final close = await show(context, message: message, timeout: timeout);
    try {
      return await operation();
    } finally {
      close();
    }
  }
}
