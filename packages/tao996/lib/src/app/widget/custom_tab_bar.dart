import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tao996/tao996.dart';

/// 标签栏项。
class MyCustomTabBarItem {
  final String key;
  final String title;
  const MyCustomTabBarItem({required this.key, required this.title});
}

/// 标签栏样式。
enum MyCustomTabBarStyle { horizontal, flow, bookMark, flowChip }

/// 自定义标签栏 — 支持 4 种样式。
class MyCustomTabBar extends StatefulWidget {
  final double height;
  final List<MyCustomTabBarItem> children;
  final RxInt activeIndex;
  final void Function(int index) onChange;
  final void Function(int index)? onDoubleTap;
  final MyCustomTabBarStyle style;
  final Color? notebookBgColor;
  final VoidCallback? onInsert;

  const MyCustomTabBar({
    super.key,
    this.height = 50,
    this.style = MyCustomTabBarStyle.horizontal,
    required this.activeIndex,
    required this.onChange,
    this.onDoubleTap,
    required this.children,
    this.notebookBgColor,
    this.onInsert,
  });

  @override
  State<MyCustomTabBar> createState() => _MyCustomTabBarState();
}

class _MyCustomTabBarState extends State<MyCustomTabBar> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final target =
        (index / math.max(1, widget.children.length - 1)) * maxScroll;
    _scrollController.animateTo(
      target.clamp(0, maxScroll),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void initState() {
    super.initState();
    widget.activeIndex.listen((index) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToIndex(index),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.style) {
      MyCustomTabBarStyle.horizontal => _buildHorizontal(context),
      MyCustomTabBarStyle.flow => _buildFlow(context),
      MyCustomTabBarStyle.bookMark => _buildBookMark(context),
      MyCustomTabBarStyle.flowChip => _buildFlowChip(context),
    };
  }

  Widget _tabLabel(ThemeData theme, int index) {
    return RxBuilder<int>(
      rx: widget.activeIndex,
      builder: (_, active) {
        final isActive = active == index;
        return DefaultTextStyle(
          style: TextStyle(
            color: isActive
                ? theme.colorScheme.primary
                : theme.textTheme.bodyLarge?.color,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
          child: Text(widget.children[index].title),
        );
      },
    );
  }

  Widget _bottomLine(ThemeData theme, int index) {
    return RxBuilder<int>(
      rx: widget.activeIndex,
      builder: (_, active) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: active == index ? 24 : 0,
        height: 3,
        margin: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.5),
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.dividerColor.withAlpha(125), width: 0.5),
        ),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        child: Row(
          children: List.generate(
            widget.children.length,
            (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      widget.activeIndex.value = i;
                      widget.onChange(i);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: _tabLabel(theme, i),
                    ),
                  ),
                  _bottomLine(theme, i),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookMark(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = widget.notebookBgColor ?? theme.scaffoldBackgroundColor;

    Widget child = SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(widget.children.length, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () {
                widget.activeIndex.value = i;
                widget.onChange(i);
              },
              child: RxBuilder<int>(
                rx: widget.activeIndex,
                builder: (_, active) {
                  final isActive = active == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.fromLTRB(16, 8, 16, isActive ? 6 : 10),
                    decoration: BoxDecoration(
                      color: isActive
                          ? bgColor
                          : theme.dividerColor.withAlpha(25),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                    child: _tabLabel(theme, i),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );

    return Container(
      height: widget.height,
      width: double.infinity,
      color: theme.dividerColor.withAlpha(25),
      child: widget.onInsert == null
          ? child
          : Row(
              children: [
                Expanded(child: child),
                IconButton(
                  onPressed: widget.onInsert,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
    );
  }

  Widget _buildFlow(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withAlpha(125),
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Wrap(
          spacing: 16,
          runSpacing: 10,
          children: List.generate(
            widget.children.length,
            (i) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    widget.activeIndex.value = i;
                    widget.onChange(i);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    child: _tabLabel(theme, i),
                  ),
                ),
                _bottomLine(theme, i),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlowChip(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withAlpha(125),
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            widget.children.length,
            (i) => InkWell(
              onTap: () {
                widget.activeIndex.value = i;
                widget.onChange(i);
              },
              child: RxBuilder<int>(
                rx: widget.activeIndex,
                builder: (_, active) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: active == i
                        ? theme.colorScheme.primary.withAlpha(25)
                        : theme.dividerColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active == i
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: _tabLabel(theme, i),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
