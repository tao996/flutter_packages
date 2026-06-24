import 'package:flutter/material.dart';
import 'package:tao996/tao996.dart';

/// 对话框工具类。
/// 替代 GetX 中依赖 Get.dialog / Get.back 的版本。
class DialogHelper {
  const DialogHelper();

  /// 对话框标题行。
  Widget title(
    BuildContext context,
    String title, {
    Widget? titleWidget,
    List<Widget>? actions,
    bool replace = false,
    double? vertical = 10,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical ?? 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child:
                titleWidget ??
                Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          if (actions != null) ...actions,
          if (!replace)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
        ],
      ),
    );
  }

  /// 打开全屏对话框。
  Future<dynamic> fullScreenDialog(
    BuildContext context, {
    required Widget child,
    double? width,
    double? height,
    bool? barrierDismissible,
    double horizontalPadding = 20,
    double verticalPadding = 20,
  }) async {
    final screenSize = MediaQuery.of(context).size;
    width ??= screenSize.width - horizontalPadding;
    height ??= screenSize.height - verticalPadding;

    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: SizedBox(
          width: width!.toInt().toDouble(),
          height: height!.toInt().toDouble(),
          child: child,
        ),
      ),
    );
  }

  /// 打开普通对话框。
  Future<dynamic> open(
    BuildContext context, {
    required Widget child,
    double? width,
    double? height,
    bool fullScreen = false,
  }) async {
    if (fullScreen) {
      return fullScreenDialog(
        context,
        child: child,
        width: width,
        height: height,
      );
    }
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: width != null || height != null
            ? SizedBox(width: width, height: height, child: child)
            : child,
      ),
    );
  }

  /// 表单对话框。
  Future<void> form(
    BuildContext context, {
    required String title,
    required List<Widget> children,
    required VoidCallback onSubmit,
    bool fullScreen = false,
    VoidCallback? onDelete,
    GlobalKey<FormState>? formKey,
  }) async {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        titleRow(context, title, onDelete: onDelete),
        ...children,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: onDelete != null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.end,
            children: [
              if (onDelete != null)
                MyButton(
                  text: i18n('delete', '删除'),
                  onPressed: onDelete,
                  status: MyButtonStatus.danger,
                ),
              MySaveButton(
                onPressed: () {
                  if (formKey != null && !formKey.currentState!.validate()) {
                    return;
                  }
                  onSubmit();
                },
              ),
            ],
          ),
        ),
      ],
    );
    await open(
      context,
      fullScreen: fullScreen,
      child: Form(key: formKey, child: content),
    );
  }

  Widget titleRow(
    BuildContext context,
    String title, {
    VoidCallback? onDelete,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// 单选列表对话框。
  void radioList<T>({
    required BuildContext context,
    required String title,
    required List<KV<T>> items,
    T? value,
    required void Function(T?) onSubmit,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: StatefulBuilder(
          builder: (ctx, setState) => RadioGroup<T>(
            groupValue: value,
            onChanged: (v) {
              value = v;
              setState(() {});
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: items
                  .map(
                    (kv) => RadioListTile<T>(
                      value: kv.value,
                      title: Text(kv.label),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(i18n('cancel', '取消')),
          ),
          TextButton(
            onPressed: () {
              onSubmit(value);
              Navigator.pop(ctx);
            },
            child: Text(i18n('confirm', '确定')),
          ),
        ],
      ),
    );
  }

  /// 底部弹出面板。
  Future<T?> showBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    bool scrollView = false,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        top: false,
        child: scrollView ? SingleChildScrollView(child: child) : child,
      ),
    );
  }

  /// 顶部滑入面板。
  Future<T?> showTopSheet<T>(
    BuildContext context, {
    required Widget child,
    bool scrollView = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, anim, _, child) => SlideTransition(
        position: Tween(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
      pageBuilder: (ctx, anim, _) => Align(
        alignment: Alignment.topCenter,
        child: Material(
          elevation: 10,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(12),
          ),
          child: SizedBox(
            width: MediaQuery.of(ctx).size.width,
            child: SafeArea(
              top: false,
              child: scrollView ? SingleChildScrollView(child: child) : child,
            ),
          ),
        ),
      ),
    );
  }

  /// 显示加载对话框。返回一个关闭函数
  /// 如果设置了 [timeout]，则会自动关闭
  Future<void Function()> loading(
    BuildContext context, {
    String? message,
    bool barrierDismissible = false,
    Duration? timeout,
  }) async {
    return MyLoadingDialog.show(
      context,
      message: message,
      barrierDismissible: barrierDismissible,
      timeout: timeout,
    );
  }

  /// 在异步操作 [operation] 完成后自动关闭加载框。
  Future<T> loadingWrap<T>(
    BuildContext context,
    Future<T> Function() operation, {
    String? message,
    Duration? timeout,
  }) async {
    return MyLoadingDialog.wrap(
      context,
      operation,
      message: message,
      timeout: timeout,
    );
  }
}
