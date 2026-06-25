import 'dart:io';
import 'package:share_plus/share_plus.dart';

enum ShareStatus {
  /// The user has selected an action
  success,

  /// The user dismissed the share-sheet
  dismissed,

  /// The platform succeed to share content to user
  /// but the user action can not be determined
  unavailable,
}

class MyShareHelper {
  MyShareHelper._();

  static Future<ShareStatus> file(
    File file, {
    String? text,
    String? subject,
  }) async {
    final params = ShareParams(
      text: text,
      files: [XFile(file.path)],
      subject: subject,
    );
    final result = await SharePlus.instance.share(params);
    return ShareStatus.values[result.status.index];
  }

  static Future<ShareStatus> filepath(
    String filepath, {
    String? text,
    String? subject,
  }) async {
    final params = ShareParams(
      text: text,
      files: [XFile(filepath)],
      subject: subject,
    );
    final result = await SharePlus.instance.share(params);
    return ShareStatus.values[result.status.index];
  }

  static Future<ShareStatus> text(String text, {String? subject}) async {
    final result = await SharePlus.instance.share(
      ShareParams(text: text, subject: subject),
    );
    return ShareStatus.values[result.status.index];
  }
}
