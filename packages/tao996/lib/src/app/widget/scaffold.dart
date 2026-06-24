import 'package:flutter/material.dart';
import 'package:tao996/tao996.dart';

/// 集成 SafeArea 的页面骨架。
/// 替代 GetX 中依赖 Get.width/Get.theme 的版本。
class MyScaffold extends StatelessWidget {
  final AppBar? appBar;
  final Widget? drawer;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool useSafeArea;
  final bool singleChildScrollView;
  final bool unfocusOnTap;
  final double? drawerEdgeDragWidthPercent;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const MyScaffold({
    super.key,
    this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.useSafeArea = true,
    this.singleChildScrollView = false,
    this.unfocusOnTap = false,
    this.drawerEdgeDragWidthPercent,
    this.floatingActionButtonLocation,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final child = Scaffold(
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      body: _buildBody(context),
      drawerEdgeDragWidth: drawerEdgeDragWidthPercent != null
          ? MediaQuery.of(context).size.width * drawerEdgeDragWidthPercent!
          : null,
    );
    return unfocusOnTap ? _unfocusOnTap(child) : child;
  }

  Widget _buildBody(BuildContext context) {
    Widget content = body;
    if (singleChildScrollView) {
      content = SingleChildScrollView(child: content);
    }
    return SafeArea(top: appBar == null, child: content);
  }

  Widget _unfocusOnTap(Widget child) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}

/// 适用于子内容不包含 Expanded 的小页面。
class MyMiniScaffold extends StatelessWidget {
  final AppBar appBar;
  final List<Widget> children;
  final Widget? floatingActionButton;

  const MyMiniScaffold({
    super.key,
    required this.appBar,
    required this.children,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      singleChildScrollView: true,
      appBar: appBar,
      body: MyLayout.miniColumn(children).padding(),
    );
  }
}

/// 空状态布局。
class MyEmptyStateLayout extends StatelessWidget {
  final String titleText;
  final String? descText;
  final String? buttonText;
  final void Function()? onPressed;

  const MyEmptyStateLayout({
    super.key,
    required this.titleText,
    this.descText,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final childBox = Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: colorScheme.secondary.withAlpha(125),
            ),
            const SizedBox(height: 24),
            if (titleText.isNotEmpty)
              Text(
                titleText,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface.withAlpha(200),
                ),
                textAlign: TextAlign.center,
              ),
            if (descText != null && descText!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                descText!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withAlpha(150),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onPressed != null) ...[
              const SizedBox(height: 30),
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: onPressed,
                  icon: const Icon(Icons.add),
                  label: Text(buttonText ?? i18n('create', '创建')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
    final height = MediaQuery.of(context).size.height / 2;
    return height > 400
        ? SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: childBox,
          )
        : childBox;
  }
}

/// 空状态 Widget。
class MyEmptyStateWidget extends StatelessWidget {
  final String? titleText;
  final VoidCallback? onPressed;

  const MyEmptyStateWidget({super.key, this.titleText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MyEmptyStateLayout(
      titleText: titleText ?? i18n('no_record', '暂无记录'),
      descText: onPressed == null ? null : i18n('click_to_create', '点击下方按钮创建'),
      onPressed: onPressed,
    );
  }
}

/// 内边距辅助。移动到扩展中
// class MyBodyPadding extends StatelessWidget {
//   final Widget child;
//   final double horizontal;
//   final double vertical;

//   const MyBodyPadding(
//     this.child, {
//     super.key,
//     this.horizontal = 16,
//     this.vertical = 8,
//   });

//   @override
//   Widget build(BuildContext context) => Padding(
//     padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
//     child: child,
//   );
// }

/// 灵活内边距。
class MyPadding extends StatelessWidget {
  final Widget child;
  final double? horizontal;
  final double? vertical;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;

  const MyPadding({
    super.key,
    required this.child,
    this.horizontal,
    this.vertical,
    this.left,
    this.right,
    this.top,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      left: left ?? horizontal ?? 0,
      right: right ?? horizontal ?? 0,
      top: top ?? vertical ?? 0,
      bottom: bottom ?? vertical ?? 0,
    ),
    child: child,
  );
}

// /// 事件辅助。移到扩展中
// class MyEvents {
//   const MyEvents._();

//   static Widget unfocusOnTap(Widget child) => GestureDetector(
//     onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//     child: child,
//   );

//   static Widget inkWell({VoidCallback? onTap, required Widget child}) =>
//       InkWell(onTap: onTap, child: child);
// }
