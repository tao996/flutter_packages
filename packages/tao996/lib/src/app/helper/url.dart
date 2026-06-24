import 'package:tao996/tao996.dart';
import 'package:url_launcher/url_launcher.dart';

/// URL 工具类 - 提供 URL 解析、验证、启动等功能。
///
/// 使用方式:
/// ```dart
/// // 验证 URL
/// final isValid = UrlUtil.isAbsoluteWebUri('https://example.com');
///
/// // 启动 URL
/// final result = await UrlUtil.launch('https://example.com');
/// if (result.isErr()) {
///   print(result.unwrapErr());
/// }
/// ```
class UrlHelper {
  const UrlHelper();

  /// 检查一个给定的字符串是否可以被解析成一个有效的 URI，并且这个 URI 具有一个绝对路径。
  /// 绝对路径通常以 / 开始，表示从根目录开始的完整路径。例如，/path/to/resource 是一个绝对路径。
  bool hasAbsolutePath(String uri) {
    return Uri.tryParse(uri)?.hasAbsolutePath ?? false;
  }

  /// 检查 uri 是否能成功解析，并且有 scheme (如 http, https) 和 host。
  bool isAbsoluteWebUri(String uriString) {
    final uri = Uri.tryParse(uriString);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  /// 连接主机与路径，[host] 主机；[path] 路径。
  Uri concat(String host, String path) {
    return Uri.parse(host).resolveUri(Uri.parse(path));
  }

  /// 获取 url 的主机。
  String host(String url) {
    return Uri.parse(url).host;
  }

  /// 辅助函数，用于编码 URL 查询参数。
  /// 因为 Uri 构造函数的 queryParameters 参数会将 Map 值进行自动编码，
  /// 但对于 mailto: 链接，其主题和正文部分需要手动编码。
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  /// 启动 URL（浏览器、邮件客户端等）。
  ///
  /// 返回 `Result<void, String>`：
  /// - Ok(void) 表示成功启动
  /// - Err(String) 表示失败，包含错误消息（URL 为空、无法启动等）
  ///
  /// [mode] 启动模式，默认为 LaunchMode.platformDefault
  static Future<Result<void, String>> launch(
    String url, {
    LaunchMode? mode,
  }) async {
    if (url.isEmpty) {
      return Result.err(i18n('urlIsEmpty', 'URL 为空'));
    }

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      try {
        await launchUrl(uri, mode: mode ?? LaunchMode.platformDefault);
        return Result.ok(null);
      } catch (e) {
        return Result.err(
          i18n(
            'launchUrlException',
            '启动 URL 异常: @reason',
            params: {'reason': e.toString()},
          ),
        );
      }
    } else {
      return Result.err(
        i18n('cannotLaunchUrl', '无法启动 URL: @reason', params: {'reason': url}),
      );
    }
  }
}
