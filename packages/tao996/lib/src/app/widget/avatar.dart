import 'dart:io';
import 'package:flutter/material.dart';

/// 头像组件 - 支持本地图片、名称首字母、默认图标。
///
/// 使用方式:
/// ```dart
/// // 显示本地图片
/// MyAvatar(logoPath: '/path/to/avatar.png', radius: 24)
///
/// // 显示名称首字母
/// MyAvatar(name: 'John Doe', radius: 24)
///
/// // 显示默认图标
/// MyAvatar(icon: Icons.person, radius: 24)
/// ```
class MyAvatar extends StatelessWidget {
  /// 头像的本地路径
  final String? logoPath;

  /// 名称，会将第1个字符作为头像显示
  final String? name;

  /// 是否使用本地头像，默认为 true
  final bool useLogo;

  /// 显示半径，默认为 18
  final double radius;

  /// 默认图标，默认为 Icons.person
  final IconData? icon;

  const MyAvatar({
    super.key,
    this.useLogo = true,
    this.logoPath,
    this.name,
    this.icon,
    this.radius = 18,
  });

  @override
  Widget build(BuildContext context) {
    if (useLogo &&
        logoPath != null &&
        logoPath!.isNotEmpty &&
        File(logoPath!).existsSync()) {
      try {
        return CircleAvatar(
          backgroundImage: FileImage(File(logoPath!)),
          radius: radius,
        );
      } catch (error) {
        return CircleAvatar(
          radius: radius,
          child: Icon(icon ?? Icons.person),
        );
      }
    }
    if (name != null && name!.isNotEmpty) {
      return CircleAvatar(radius: radius, child: Text(name![0]));
    }
    return CircleAvatar(radius: radius, child: Icon(icon ?? Icons.person));
  }
}
