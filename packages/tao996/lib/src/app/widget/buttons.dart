import 'package:flutter/material.dart';
import 'package:tao996/tao996.dart';

/// 按钮状态。
enum MyButtonStatus { primary, secondary, danger, warning, success, info }

/// 按钮样式类型。
enum MyButtonType { outlined, text, filled, filledTonal, elevated }

/// 多功能按钮 — Flutter 原生参数风格。
///
/// ```dart
/// MyButton(text: '保存', onPressed: _save)
/// MyButton(child: Icon(Icons.add), onPressed: _add)
/// MyButton(text: '加载中', loading: true, onPressed: _save)
/// ```
class MyButton extends StatelessWidget {
  /// 按钮文本。与 [child] 二选一，[child] 优先。
  final String? text;

  /// 自定义子组件。传入时忽略 [text]。
  final Widget? child;

  /// 点击回调。
  final VoidCallback? onPressed;

  /// 是否加载中。加载时禁用点击。
  final bool loading;

  /// 是否启用。默认 true，[onPressed] 为 null 时自动禁用。
  final bool enabled;

  /// 按钮图标。
  final Widget? icon;

  /// 按钮状态色。
  final MyButtonStatus status;

  /// 按钮样式类型。
  final MyButtonType? type;

  /// 圆角。
  final double borderRadius;

  /// 内边距。
  final EdgeInsetsGeometry? padding;

  /// 按钮宽度。
  final double? width;

  /// 按钮高度。
  final double? height;

  /// 背景色（覆盖 status）。
  final Color? backgroundColor;

  /// 前景色（覆盖 status）。
  final Color? foregroundColor;

  /// 提示文本。
  final String? tooltip;

  const MyButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.loading = false,
    this.enabled = true,
    this.icon,
    this.status = MyButtonStatus.primary,
    this.type,
    this.borderRadius = 4,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (base, onBase) = _resolveColors(colorScheme);
    final isDisabled = loading || !enabled || onPressed == null;
    final currentChild = child ?? (text != null ? Text(text!) : null);

    Widget btn = _buildButton(base, onBase, currentChild, isDisabled);
    if (tooltip != null && !isDisabled) {
      btn = Tooltip(message: tooltip!, child: btn);
    }
    return btn;
  }

  Widget _buildButton(Color base, Color onBase, Widget? label, bool disabled) {
    final bgColor = backgroundColor ?? (disabled ? base.withAlpha(125) : base);
    final fgColor =
        foregroundColor ?? (disabled ? base.withAlpha(125) : onBase);
    final btnType = type ?? MyButtonType.text;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (loading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: fgColor),
          )
        else
          ?icon,
        if (loading || icon != null) const SizedBox(width: 8),
        ?label,
      ],
    );

    final style = _style(btnType, bgColor, fgColor);

    Widget btn;
    switch (btnType) {
      case MyButtonType.filled:
        btn = FilledButton(
          style: style,
          onPressed: disabled ? null : onPressed,
          child: content,
        );
      case MyButtonType.filledTonal:
        btn = FilledButton.tonal(
          style: style,
          onPressed: disabled ? null : onPressed,
          child: content,
        );
      case MyButtonType.elevated:
        btn = ElevatedButton(
          style: style,
          onPressed: disabled ? null : onPressed,
          child: content,
        );
      case MyButtonType.outlined:
        btn = OutlinedButton(
          style: style,
          onPressed: disabled ? null : onPressed,
          child: content,
        );
      case MyButtonType.text:
        btn = TextButton(
          style: style,
          onPressed: disabled ? null : onPressed,
          child: content,
        );
    }

    if (width != null || height != null) {
      btn = SizedBox(width: width, height: height, child: btn);
    }
    return btn;
  }

  (Color, Color) _resolveColors(ColorScheme scheme) => switch (status) {
    MyButtonStatus.primary => (scheme.primary, scheme.onPrimary),
    MyButtonStatus.secondary => (scheme.secondary, scheme.onSecondary),
    MyButtonStatus.danger => (scheme.error, scheme.onError),
    MyButtonStatus.warning => (Colors.orange, Colors.white),
    MyButtonStatus.success => (Colors.green, Colors.white),
    MyButtonStatus.info => (Colors.blue, Colors.white),
  };

  ButtonStyle? _style(MyButtonType type, Color bg, Color fg) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );

    switch (type) {
      case MyButtonType.filled:
      case MyButtonType.filledTonal:
        return FilledButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          shape: shape,
          padding: padding,
        );
      case MyButtonType.elevated:
        return ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: enabled ? 4 : 0,
          shape: shape,
          padding: padding,
        );
      case MyButtonType.outlined:
        return OutlinedButton.styleFrom(
          foregroundColor: fg,
          side: BorderSide(color: bg),
          shape: shape,
          padding: padding,
        );
      case MyButtonType.text:
        return TextButton.styleFrom(
          foregroundColor: fg,
          shape: shape,
          padding: padding,
        );
    }
  }
}

/// 保存按钮。
class MySaveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool loading;
  final String? label;

  const MySaveButton({
    super.key,
    this.onPressed,
    this.loading = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) => MyButton(
    text: label ?? i18n('save', '保存'),
    onPressed: onPressed,
    loading: loading,
    icon: const Icon(Icons.save_outlined),
  );
}

/// 取消按钮。不再内部调用 Navigator.pop，由调用方决定。
class MyCancelButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isBack;

  const MyCancelButton({super.key, this.onPressed, this.isBack = false});

  @override
  Widget build(BuildContext context) => MyButton(
    text: isBack ? i18n('back', '返回') : i18n('cancel', '取消'),
    onPressed: onPressed ?? () => Navigator.pop(context),
    icon: Icon(isBack ? Icons.navigate_before : Icons.clear),
    status: MyButtonStatus.secondary,
  );
}

/// 删除按钮。
class MyDeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool confirm;

  const MyDeleteButton({super.key, this.onPressed, this.confirm = true});

  @override
  Widget build(BuildContext context) => MyButton(
    text: i18n('delete', '删除'),
    onPressed: onPressed,
    icon: Icon(Icons.delete_outline, color: tu.color.danger),
    status: MyButtonStatus.danger,
  );
}

/// 添加按钮。
class MyInsertButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;

  const MyInsertButton({super.key, this.label, this.onPressed});

  @override
  Widget build(BuildContext context) => MyButton(
    text: label ?? i18n('add', '添加'),
    onPressed: onPressed,
    icon: const Icon(Icons.add),
  );
}

/// 编辑按钮。
class MyEditButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;

  const MyEditButton({super.key, this.label, this.onPressed});

  @override
  Widget build(BuildContext context) => MyButton(
    text: label ?? i18n('edit', '编辑'),
    onPressed: onPressed,
    icon: const Icon(Icons.edit),
  );
}

/// 菜单按钮项。
class MyMenuButtonItem {
  final String text;
  final IconData? iconData;
  final Color? color;
  final Future<void> Function() onPressed;

  const MyMenuButtonItem({
    required this.text,
    required this.onPressed,
    this.iconData,
    this.color,
  });
}

class MyMenuButtons extends StatelessWidget {
  final List<List<MyMenuButtonItem>> items;

  const MyMenuButtons({super.key, required this.items});

  @override
  Widget build(BuildContext context) => PopupMenuButton<MyMenuButtonItem>(
    icon: const Icon(Icons.more_vert),
    onSelected: (item) async => item.onPressed(),
    itemBuilder: (_) => _buildItems(),
  );

  List<PopupMenuEntry<MyMenuButtonItem>> _buildItems() {
    final entries = <PopupMenuEntry<MyMenuButtonItem>>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) entries.add(const PopupMenuDivider());
      for (final item in items[i]) {
        entries.add(
          PopupMenuItem(
            value: item,
            child: Row(
              children: [
                if (item.iconData != null) ...[
                  Icon(item.iconData!, size: 20, color: item.color),
                  const SizedBox(width: 8),
                ],
                Text(item.text, style: TextStyle(color: item.color)),
              ],
            ),
          ),
        );
      }
    }
    return entries;
  }
}

/// 添加图标按钮（纯图标版本）。
class MyAddIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? tooltip;

  const MyAddIconButton({super.key, this.onPressed, this.tooltip});

  @override
  Widget build(BuildContext context) => IconButton(
    icon: const Icon(Icons.add),
    onPressed: onPressed,
    tooltip: tooltip ?? i18n('add', '添加'),
  );
}

/// 编辑图标按钮（纯图标版本）。
class MyEditIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? tooltip;

  const MyEditIconButton({super.key, this.onPressed, this.tooltip});

  @override
  Widget build(BuildContext context) => IconButton(
    icon: const Icon(Icons.edit),
    onPressed: onPressed,
    tooltip: tooltip ?? i18n('edit', '编辑'),
  );
}

/// 删除图标按钮（纯图标版本）。
class MyDeleteIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? tooltip;

  const MyDeleteIconButton({super.key, this.onPressed, this.tooltip});

  @override
  Widget build(BuildContext context) => IconButton(
    icon: Icon(Icons.delete_outline, color: tu.color.danger),
    onPressed: onPressed,
    tooltip: tooltip ?? i18n('delete', '删除'),
  );
}

/// QR 扫描按钮。
class MyQrcodeIconButton extends StatelessWidget {
  final void Function(String?) onChange;

  const MyQrcodeIconButton({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) => IconButton(
    icon: const Icon(Icons.qr_code_scanner),
    onPressed: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _QRCodePlaceholder()),
    ).then((result) => onChange(result as String?)),
    tooltip: i18n('scanQrCode', '扫描二维码'),
  );
}

class _QRCodePlaceholder extends StatelessWidget {
  const _QRCodePlaceholder();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('QR Code Scan')));
}
