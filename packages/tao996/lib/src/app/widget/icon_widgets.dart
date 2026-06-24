import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// 动画图标组件 - 支持旋转动画的图标。
///
/// 使用方式:
/// ```dart
/// MyAnimatedIcon(
///   icon: Icons.refresh,
///   isLoading: true,
///   size: 24,
/// )
/// ```
class MyAnimatedIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final bool isLoading;
  final Color? color;

  const MyAnimatedIcon({
    super.key,
    this.icon = Icons.refresh,
    this.size = 18,
    this.isLoading = false,
    this.color,
  });

  @override
  State<MyAnimatedIcon> createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<MyAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant MyAnimatedIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: widget.isLoading
          ? RotationTransition(
              turns: _controller,
              child: Icon(widget.icon, size: widget.size, color: widget.color),
            )
          : Icon(widget.icon, size: widget.size, color: widget.color),
    );
  }
}

/// 图标/SVG 组件 - 支持 IconData、Asset、本地文件、网络图片。
///
/// 使用方式:
/// ```dart
/// // IconData
/// MyIconSvg(Icons.home, size: 24)
///
/// // Asset SVG
/// MyIconSvg('assets/icons/logo.svg', size: 24)
///
/// // 本地文件
/// MyIconSvg('/path/to/icon.svg', size: 24)
///
/// // 网络图片
/// MyIconSvg('https://example.com/icon.svg', size: 24)
///
/// // 短文本
/// MyIconSvg('AB', size: 24)
/// ```
class MyIconSvg extends StatelessWidget {
  final double? size;
  final Color? color;
  final dynamic data;
  final int textLength;
  final BoxFit boxFit;

  /// 显示图像或图标的组件，优先级：IconData > Asset 资源 > 本地文件
  ///
  /// 支持第3方包 `packages:【包名】/【资源路径】` 如 `packages/tao996/assets/images/logo.png`
  const MyIconSvg(
    this.data, {
    super.key,
    this.size = 24,
    this.color,
    this.textLength = 7,
    this.boxFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // 优先级：IconData > 本地文件 > Asset 资源
    if (data is IconData) {
      return Icon(data, size: size, color: color);
    }
    if (data is String && (data as String).isNotEmpty) {
      final Color finalColor =
          color ?? Theme.of(context).iconTheme.color ?? Colors.black;

      // 显示短文本
      if ((data as String).length < textLength) {
        return Text(
          (data as String),
          style: TextStyle(fontSize: size, color: finalColor),
        );
      }

      final ColorFilter colorFilter = ColorFilter.mode(
        finalColor,
        BlendMode.srcIn,
      );

      // assets 资源
      if ((data as String).startsWith('assets/') ||
          (data as String).startsWith('packages/')) {
        return SvgPicture.asset(
          data,
          fit: boxFit,
          colorFilter: colorFilter,
          width: size,
          height: size,
        );
      }
      // 网络资源
      else if ((data as String).startsWith('https://') ||
          (data as String).startsWith('http://')) {
        return SvgPicture.network(
          data,
          fit: boxFit,
          colorFilter: colorFilter,
          width: size,
          height: size,
        );
      }

      final file = File(data as String);
      if (file.existsSync()) {
        if (data.toLowerCase().endsWith('.svg')) {
          return SvgPicture.file(
            file,
            fit: boxFit,
            colorFilter: colorFilter,
            width: size,
            height: size,
          );
        }
        return Image.file(
          file,
          width: size,
          height: size,
          fit: boxFit,
          color: color,
        );
      }
    }
    return SizedBox(
      width: size,
      height: size,
      child: Container(color: color),
    );
  }
}
