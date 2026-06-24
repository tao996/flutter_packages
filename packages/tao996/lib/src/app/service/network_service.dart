import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// 网络服务 — 网络状态监听、在线/离线检测。
class NetworkService {
  final Connectivity _connectivity;
  final _controller = StreamController<bool>.broadcast();
  bool _isOnline = true;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  NetworkService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity() {
    _init();
  }

  void _init() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _isOnline = !results.contains(ConnectivityResult.none);
      _controller.add(_isOnline);
    });
  }

  /// 是否在线。
  bool isOnline() => _isOnline;

  /// 监听网络状态变化。
  Stream<bool> get onStatusChanged => _controller.stream;

  /// 释放资源。
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
