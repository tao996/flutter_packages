import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

class MyCryptoUtil {
  MyCryptoUtil._();

  static String md5Text(String input) {
    return md5Bytes(utf8.encode(input));
  }

  static String md5Bytes(List<int> bytes) {
    return crypto.md5.convert(bytes).toString();
  }

  static String sha256Text(String input) {
    return sha256Bytes(utf8.encode(input));
  }

  static String sha256Bytes(List<int> bytes) {
    return crypto.sha256.convert(bytes).toString();
  }
}
