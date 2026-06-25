import 'package:dio/dio.dart';
import 'package:tao996/tao996.dart';

/// HTTP 服务 — 基于 Dio 的 HTTP 请求封装。
///
/// 提供 GET / POST / HEAD / download 等常用方法。
/// 自动检查网络状态，失败时返回 [Result.err]。
class MyHttpService {
  final Dio _dio;
  final MyNetworkService _network;

  MyHttpService({required Dio dio, required MyNetworkService network})
    : _dio = dio,
      _network = network;

  /// GET 请求。
  Future<MyResult<T, String>> get<T>(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (!_network.isOnline()) {
      return MyResult.err(i18n('networkOffline', '网络未连接'));
    }
    try {
      final resp = await _dio.get(
        url,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken,
      );
      return MyResult.ok(resp.data as T);
    } catch (e) {
      return MyResult.err(e.toString());
    }
  }

  /// POST 请求。
  Future<MyResult<T, String>> post<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    if (!_network.isOnline()) {
      return MyResult.err(i18n('networkOffline', '网络未连接'));
    }
    try {
      final resp = await _dio.post(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return MyResult.ok(resp.data as T);
    } catch (e) {
      return MyResult.err(e.toString());
    }
  }

  /// HEAD 请求。
  Future<MyResult<T, String>> head<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (!_network.isOnline()) {
      return MyResult.err(i18n('networkOffline', '网络未连接'));
    }
    try {
      final resp = await _dio.head(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken,
      );
      return MyResult.ok(resp.data as T);
    } catch (e) {
      return MyResult.err(e.toString());
    }
  }

  /// 下载文件到本地路径。
  Future<MyResult<String, String>> download(
    String url,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (!_network.isOnline()) {
      return MyResult.err(i18n('networkOffline', '网络未连接'));
    }
    try {
      final resp = await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        options: options,
        cancelToken: cancelToken,
      );
      if (resp.statusCode == 200) {
        return MyResult.ok(savePath);
      }
      return MyResult.err(
        i18n(
          'downloadFailed',
          '下载失败:@reason',
          params: {'reason': resp.statusCode},
        ),
      );
    } catch (e) {
      return MyResult.err(e.toString());
    }
  }
}
