/// 应用异常基类。
class AppException implements Exception {
  final String message;
  final Object? cause;

  AppException(this.message, {this.cause});

  @override
  String toString() => 'AppException: $message';
}

/// 简单异常 — 用于需要用户提示的场景。
class AppEasyException implements Exception {
  final String message;

  AppEasyException(this.message);

  @override
  String toString() => message;
}

/// 网络异常。
class NetworkException extends AppException {
  final int? statusCode;

  NetworkException(super.message, {this.statusCode, super.cause});
}

/// 数据库异常。
class DatabaseException extends AppException {
  DatabaseException(super.message, {super.cause});
}

/// 服务未注册异常。
class ServiceNotRegisteredException extends AppException {
  ServiceNotRegisteredException(Type type)
      : super('Service $type is not registered');
}
