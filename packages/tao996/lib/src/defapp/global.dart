import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tao996/defapp.dart';
import 'package:tao996/tao996.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyGlobal {
  final Di _di = Di();
  ColorScheme? _colorScheme;
  SharedPreferences? _prefs;

  ColorScheme get colorScheme => _colorScheme!;
  Di get di => _di;
  DeviceService get deviceSer => _di.get<DeviceService>();
  FontService get fontSer => _di.get<FontService>();
  NetworkService get networkSer => _di.get<NetworkService>();
  HttpService get httpSer => _di.get<HttpService>();
  LocaleService get localeSer => _di.get<LocaleService>();
  MessageService get messageSer => _di.get<MessageService>();
  MySettingHelper get settingHelper => _di.get<MySettingHelper>();
  MyThemeHelper get themeHelper => _di.get<MyThemeHelper>();

  /// 翻译管理
  TranslationManager get tm => TranslationManager.instance;
  SharedPreferences get prefs => _prefs!;

  MyGlobal() {
    _di.registerLazySingleton<DeviceService>(() {
      return DeviceService();
    });
    _di.registerLazySingleton<FontService>(() {
      return FontService();
    });
    _di.registerLazySingleton<NetworkService>(() {
      return NetworkService();
    });
    _di.registerLazySingleton<HttpService>(() {
      return HttpService(dio: Dio(), network: _di.get<NetworkService>());
    });
    _di.registerLazySingleton<LocaleService>(() {
      return LocaleService(tm: TranslationManager.instance);
    });
    _di.registerLazySingleton<MessageService>(() {
      return MessageService();
    });
  }

  /// [packages] 需要记录日志的包名
  Future<void> init(List<String> packages) async {
    logPackages(packages);
    _prefs = await SharedPreferences.getInstance();
  }

  void setColorScheme(ColorScheme colorScheme) {
    _colorScheme = colorScheme;
  }
}
