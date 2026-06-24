import 'package:flutter/material.dart';

/// 具有缓存功能的图片组件。
/// 支持网络图片、本地图片、资源图片。
class MyImageCache extends StatefulWidget {
  final dynamic data;
  final VoidCallback? onTap;
  final bool enabledTap;
  final double? size;

  const MyImageCache({
    super.key,
    required this.data,
    this.onTap,
    this.enabledTap = true,
    this.size,
  });

  @override
  State<MyImageCache> createState() => _MyImageCacheState();
}

class _MyImageCacheState extends State<MyImageCache> {
  bool _isDeviceResource = false;
  bool _isNetworkResource = false;
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    _analyzeSource();
  }

  void _analyzeSource() {
    final data = widget.data;
    if (data == null) return;
    if (data is String) {
      if (data.startsWith('assets/') || data.startsWith('packages/')) {
        _isDeviceResource = true;
      } else if (data.startsWith('http://') ||
          data.startsWith('https://') ||
          data.startsWith('//')) {
        _isNetworkResource = true;
        imageUrl = data.startsWith('//') ? 'https:$data' : data;
      } else {
        _isDeviceResource = true;
      }
    } else if (data is IconData) {
      _isDeviceResource = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDeviceResource) {
      return _gestureDetector(_buildDeviceImage());
    }
    if (_isNetworkResource && imageUrl.isNotEmpty) {
      return _gestureDetector(_buildNetworkImage());
    }
    return _gestureDetector(const Icon(Icons.image, size: 48));
  }

  Widget _buildDeviceImage() {
    final data = widget.data;
    final size = widget.size;
    if (data is String) return Image.asset(data, width: size, height: size);
    if (data is IconData) return Icon(data, size: size);
    return const Icon(Icons.image, size: 48);
  }

  Widget _buildNetworkImage() {
    return Image.network(
      imageUrl,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const Icon(Icons.broken_image, size: 48),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
    );
  }

  Widget _gestureDetector(Widget child) {
    if (!widget.enabledTap) return child;
    return GestureDetector(
      onTap: widget.onTap ?? () => _openImageViewer(context),
      child: child,
    );
  }

  void _openImageViewer(BuildContext context) {
    if (imageUrl.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: Center(
              child: InteractiveViewer(
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      );
    }
  }
}
