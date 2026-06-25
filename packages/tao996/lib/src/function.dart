import 'package:flutter/foundation.dart';

import '../tao996.dart';

/// 添加包名
/// 只有在包名内才会被打印
void myLogPackages(List<String> packages, {bool append = true}) {
  if (packages.isEmpty) {
    return;
  }
  if (append) {
    for (var package in packages) {
      package = package.startsWith('package:') ? package : 'package:$package';
      if (!MyStackUtil.debugPackages.contains(package)) {
        MyStackUtil.debugPackages.add(package);
      }
    }
  } else {
    MyStackUtil.debugPackages.clear();
    MyStackUtil.debugPackages.addAll(
      packages
          .map(
            (package) =>
                package.startsWith('package:') ? package : 'package:$package',
          )
          .toList(),
    );
  }
}

void dprint(dynamic message, {bool stack = true, bool first = true}) {
  if (kDebugMode) {
    String color = MyConsoleUtil.random();
    MyConsoleUtil.print(message.toString(), color: color);
    if (stack) {
      List<String> stacks = MyStackUtil.filter(
        ingores: ['function.dart'],
        first: first,
      );
      if (stacks.isNotEmpty) {
        MyConsoleUtil.print(stacks.join("/n").toString(), color: color);
      }
    }
  }
}

void ddprint(dynamic message, dynamic args) {
  if (kDebugMode) {
    MyConsoleUtil.print('[DEBUG] $message${args != null ? ' | $args' : ''}');
  }
}

void dexception(Object error, Object stackTrace, {String? errorMessage}) {
  if (kDebugMode) {
    String color = MyConsoleUtil.random();
    MyConsoleUtil.print('[ERROR] ${errorMessage ?? error}', color: color);
    MyConsoleUtil.print(stackTrace.toString(), color: color);
  }
}
