import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tao996/tao996.dart';

/// 二维码生成视图。
class QRCodeView extends StatelessWidget {
  final String data;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget? embeddedImage;
  final double embeddedImageSize;

  const QRCodeView({
    super.key,
    required this.data,
    this.size = 200,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.embeddedImage,
    this.embeddedImageSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            i18n('qrCodeEmpty', '二维码数据为空'),
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ),
      );
    }

    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      backgroundColor: backgroundColor,
      eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: foregroundColor),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: foregroundColor,
      ),
      embeddedImage: embeddedImage != null
          ? (embeddedImage as ImageProvider?)
          : null,
      embeddedImageStyle: QrEmbeddedImageStyle(
        size: Size.square(embeddedImageSize),
      ),
    );
  }
}
