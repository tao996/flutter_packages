import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

class CryptoUtil {
  const CryptoUtil();

  String md5Text(String input) {
    return md5Bytes(utf8.encode(input));
  }

  String md5Bytes(List<int> bytes) {
    return crypto.md5.convert(bytes).toString();
  }

  String sha256Text(String input) {
    return sha256Bytes(utf8.encode(input));
  }

  String sha256Bytes(List<int> bytes) {
    return crypto.sha256.convert(bytes).toString();
  }
}
