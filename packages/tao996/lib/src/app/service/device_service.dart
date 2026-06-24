import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

/// 设备服务 — 设备信息、平台、屏幕尺寸。
class DeviceService {
  final DeviceInfoPlugin _plugin;

  DeviceService({DeviceInfoPlugin? plugin}) : _plugin = plugin ?? DeviceInfoPlugin();

  /// 获取平台名称。
  String getPlatform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  /// 获取屏幕尺寸。
  Size getScreenSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size;
  }

  /// 获取设备信息（异步）。
  Future<Map<String, dynamic>> getDeviceInfo() async {
    if (Platform.isAndroid) {
      final info = await _plugin.androidInfo;
      return {'model': info.model, 'version': info.version.sdkInt};
    }
    if (Platform.isIOS) {
      final info = await _plugin.iosInfo;
      return {'model': info.model, 'version': info.systemVersion};
    }
    return {'platform': getPlatform()};
  }
}
