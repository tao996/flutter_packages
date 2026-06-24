import 'package:permission_handler/permission_handler.dart';
import 'package:tao996/src/translation/translation.dart';

/// 权限工具类 - 封装常用的权限请求操作。
class PermissionHelper {
  const PermissionHelper();

  /// 请求麦克风权限，如果未授权则抛出异常。
  Future<void> mustMicrophone() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception(i18n('permission.microphone', '麦克风权限未授权'));
    }
  }
}
