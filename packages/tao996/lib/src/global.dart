import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tao996/tao996.dart';

final myGlobal = MyGlobal();

class MyGlobal {
  final Di _di = Di();
  ColorScheme? _colorScheme;

  ColorScheme get colorScheme => _colorScheme!;
  Di get di => _di;
  DeviceService get deviceSer => _di.get<DeviceService>();
  FontService get fontSer => _di.get<FontService>();
  NetworkService get networkSer => _di.get<NetworkService>();
  HttpService get httpSer => _di.get<HttpService>();
  LocaleService get localeSer => _di.get<LocaleService>();
  MessageService get messageSer => _di.get<MessageService>();
  TranslationManager get tm => TranslationManager.instance;

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

  void setColorScheme(ColorScheme colorScheme) {
    _colorScheme = colorScheme;
  }
}
