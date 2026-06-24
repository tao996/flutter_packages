import 'package:flutter/material.dart';

/// 网络图片（带缓存、占位符、错误处理）。
///
/// 使用 Flutter 内置 Image.network，在测试环境可无缝替换。
class MyNetworkImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const MyNetworkImage({
    super.key,
    this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (url == null || url!.isEmpty) {
      image = errorWidget ?? _defaultError();
    } else {
      image = Image.network(
        url!,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (ctx, child, progress) {
          if (progress == null) return child;
          return placeholder ?? _defaultPlaceholder();
        },
        errorBuilder: (ctx, error, stackTrace) {
          return errorWidget ?? _defaultError();
        },
      );
    }

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return SizedBox(width: width, height: height, child: image);
  }

  Widget _defaultPlaceholder() => Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey.shade400),
        ),
      );

  Widget _defaultError() => Center(
        child: Icon(Icons.broken_image_outlined, color: Colors.grey.shade400, size: 32),
      );
}
