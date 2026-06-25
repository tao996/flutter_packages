import 'package:flutter/material.dart';

/// 路由名称。
typedef RouteName = String;

/// 路由参数。
typedef RouteArguments = dynamic;

/// 路由请求。
class RouteRequest {
  final RouteName name;
  final RouteArguments? arguments;

  const RouteRequest({required this.name, this.arguments});
}

/// 路由建造器类型。
typedef RouteBuilder = Widget Function(RouteRequest request);

/// 路由注册表 — 替代 GetPage。
///
/// 所有路由通过此注册表注册和解析，参数通过 [RouteRequest] 传递。
class RouteRegistry {
  RouteRegistry._();

  static final Map<RouteName, RouteBuilder> _routes = {};

  /// 注册路由。
  static void register(RouteName name, RouteBuilder builder) {
    _routes[name] = builder;
  }

  /// 取消注册。
  static void unregister(RouteName name) {
    _routes.remove(name);
  }

  /// 是否已注册。
  static bool contains(RouteName name) => _routes.containsKey(name);

  /// 解析路由，返回注册的建造器。
  static RouteBuilder? resolve(RouteRequest request) => _routes[request.name];

  /// 清除所有路由。
  static void clear() => _routes.clear();
}

/// 导航适配器 — 替代 Get.to / Get.back / Get.toNamed。
class NavigationAdapter {
  NavigationAdapter._();

  /// 推入命名路由。
  static Future<T?> pushNamed<T>(
    BuildContext context,
    RouteName name, {
    RouteArguments? arguments,
  }) {
    return Navigator.pushNamed<T>(context, name, arguments: arguments);
  }

  /// 返回上一页。
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  /// 替换当前路由。
  static Future<T?> pushReplacementNamed<T, TO>(
    BuildContext context,
    RouteName name, {
    RouteArguments? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      name,
      arguments: arguments,
    );
  }
}

/// AppRoutes — 应用路由表。
///
/// 替代 GetPage / GetMaterialApp 的路由配置。
class AppRoutes {
  AppRoutes._();

  /// 初始路由。
  static const String initialRoute = '/';

  /// 注册路由（委托给 [RouteRegistry]）。
  static void register(RouteName name, RouteBuilder builder) {
    RouteRegistry.register(name, builder);
  }

  /// 生成路由（用于 MaterialApp.onGenerateRoute）。
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final request = RouteRequest(
      name: settings.name ?? '/',
      arguments: settings.arguments,
    );
    final builder = RouteRegistry.resolve(request);
    if (builder == null) return null;

    return MaterialPageRoute<dynamic>(
      builder: (_) => builder(request),
      settings: settings,
    );
  }
}
