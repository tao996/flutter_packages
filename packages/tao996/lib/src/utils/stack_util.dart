/// 堆栈工具 — 格式化调用堆栈、过滤特定包名。
class StackUtil {
  const StackUtil();

  /// 允许打印的包名
  static final List<String> debugPackages = ['package:tao996'];

  /// 检查是否在打印的包内
  bool inPackageLine(String line) {
    if (line.contains('stack.dart')) {
      return false;
    }
    for (String package in debugPackages) {
      if (line.contains(package)) {
        return true;
      }
    }
    return false;
  }

  /// 打印栈信息
  /// [ingores] 过滤掉这些信息
  /// [first] 只打印第 1 条信息
  List<String> filter({List<String>? ingores, bool first = false}) {
    List<String> messages = [];

    for (String line in getStackTraceString()) {
      if (inPackageLine(line)) {
        if (ingores != null && ingores.any((name) => line.contains(name))) {
          continue;
        }
        messages.add(line);
        if (first) {
          break;
        }
      }
    }
    return messages;
  }

  List<String> getStackTraceString({StackTrace? stackTrace}) {
    StackTrace st = stackTrace ?? StackTrace.current;
    String stackTraceString = st.toString();
    return stackTraceString.split('\n');
  }
}
