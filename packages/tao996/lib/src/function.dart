import 'package:flutter/foundation.dart';

import '../tao996.dart';

/// 添加包名
/// 只有在包名内才会被打印
void logPackages(List<String> packages, {bool append = true}) {
  if (packages.isEmpty) {
    return;
  }
  if (append) {
    for (var package in packages) {
      package = package.startsWith('package:') ? package : 'package:$package';
      if (!StackUtil.debugPackages.contains(package)) {
        StackUtil.debugPackages.add(package);
      }
    }
  } else {
    StackUtil.debugPackages.clear();
    StackUtil.debugPackages.addAll(
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
    String color = tu.console.random();
    tu.console.print(message.toString(), color: color);
    if (stack) {
      List<String> stacks = tu.stack.filter(
        ingores: ['function.dart'],
        first: first,
      );
      if (stacks.isNotEmpty) {
        tu.console.print(stacks.join("/n").toString(), color: color);
      }
    }
  }
}

void ddprint(dynamic message, dynamic args) {
  if (kDebugMode) {
    tu.console.print('[DEBUG] $message${args != null ? ' | $args' : ''}');
  }
}

void dexception(Object error, Object stackTrace, {String? errorMessage}) {
  if (kDebugMode) {
    String color = tu.console.random();
    tu.console.print('[ERROR] ${errorMessage ?? error}', color: color);
    tu.console.print(stackTrace.toString(), color: color);
  }
}
