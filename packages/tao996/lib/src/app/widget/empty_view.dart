import 'package:flutter/material.dart';
import 'package:tao996/tao996.dart';

/// 空状态类型。
enum EmptyType { noData, noNetwork, noPermission, custom }

/// 空状态页（无数据、无网络、无权限）。
class EmptyView extends StatelessWidget {
  final EmptyType type;
  final String? message;
  final Widget? icon;
  final VoidCallback? onRetry;
  final String? retryText;

  const EmptyView({
    super.key,
    this.type = EmptyType.noData,
    this.message,
    this.icon,
    this.onRetry,
    this.retryText,
  });

  const EmptyView.noData({
    super.key,
    this.message,
    this.onRetry,
    this.retryText,
    this.icon,
  }) : type = EmptyType.noData;

  const EmptyView.noNetwork({
    super.key,
    this.message,
    this.onRetry,
    this.retryText,
    this.icon,
  }) : type = EmptyType.noNetwork;

  const EmptyView.noPermission({
    super.key,
    this.message,
    this.onRetry,
    this.retryText,
    this.icon,
  }) : type = EmptyType.noPermission;

  IconData get _defaultIcon {
    switch (type) {
      case EmptyType.noData:
        return Icons.inbox_outlined;
      case EmptyType.noNetwork:
        return Icons.wifi_off_outlined;
      case EmptyType.noPermission:
        return Icons.lock_outline;
      case EmptyType.custom:
        return Icons.info_outline;
    }
  }

  String _defaultMessage(BuildContext context) {
    switch (type) {
      case EmptyType.noData:
        return i18n('emptyNoData', '暂无数据');
      case EmptyType.noNetwork:
        return i18n('emptyNoNetwork', '网络连接失败');
      case EmptyType.noPermission:
        return i18n('emptyNoPermission', '无权限访问');
      case EmptyType.custom:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final msg = message ?? _defaultMessage(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ?? Icon(_defaultIcon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          if (msg.isNotEmpty)
            Text(
              msg,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: Text(retryText ?? i18n('retry', '重试')),
            ),
          ],
        ],
      ),
    );
  }
}
