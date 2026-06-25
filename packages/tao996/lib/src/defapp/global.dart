import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tao996/defapp.dart';
import 'package:tao996/tao996.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyGlobal {
  final MyDi _di = MyDi();
  ColorScheme? _colorScheme;
  SharedPreferences? _prefs;
  String? _homeDir;

  ColorScheme get colorScheme => _colorScheme!;
  MyDi get di => _di;
  MyDeviceService get deviceSer => _di.get<MyDeviceService>();
  MyFontService get fontSer => _di.get<MyFontService>();
  MyNetworkService get networkSer => _di.get<MyNetworkService>();
  MyHttpService get httpSer => _di.get<MyHttpService>();
  MyLocaleService get localeSer => _di.get<MyLocaleService>();
  MySettingHelper get settingHelper => _di.get<MySettingHelper>();
  MyThemeHelper get themeHelper => _di.get<MyThemeHelper>();
  ILogService get logSer => _di.get<ILogService>();

  /// 翻译管理
  TranslationManager get tm => TranslationManager.instance;
  SharedPreferences get prefs => _prefs!;
  String get homeDir => _homeDir!;

  MyGlobal() {
    dprint("准备注册服务");
    _di.registerLazySingleton<MyDeviceService>(() {
      return MyDeviceService();
    });
    _di.registerLazySingleton<MyFontService>(() {
      return MyFontService();
    });
    _di.registerLazySingleton<MyNetworkService>(() {
      return MyNetworkService();
    });
    _di.registerLazySingleton<MyHttpService>(() {
      return MyHttpService(dio: Dio(), network: _di.get<MyNetworkService>());
    });
    _di.registerLazySingleton<MyLocaleService>(() {
      return MyLocaleService(tm: TranslationManager.instance);
    });
    _di.registerLazySingleton<ILogService>(() {
      return MyLogService();
    });
    debugPrint("注册服务完成");
  }

  /// [packages] 需要记录日志的包名
  Future<void> init(List<String> packages) async {
    myLogPackages(packages);
    _prefs = await SharedPreferences.getInstance();
    _homeDir = await MyPathHelper.homeDir();
  }

  void setColorScheme(ColorScheme colorScheme) {
    _colorScheme = colorScheme;
  }
}
