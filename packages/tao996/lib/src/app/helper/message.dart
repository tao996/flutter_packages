import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 消息服务 — 提示 Toast / SnackBar。
class MyMessageHelper {
  MyMessageHelper._();

  /// 显示成功提示。
  static void success(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );
  }

  /// 显示错误提示。
  static void error(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );
  }

  /// 显示普通提示。
  static void info(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );
  }

  /// 显示警告提示。
  static void warning(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
