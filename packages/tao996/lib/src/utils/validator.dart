import 'package:tao996/src/translation/translation.dart';

/// 数据校验器 — 链式调用，纯 Dart。
///
/// ```dart
/// final result = Validator()
///   .required(name, '姓名')
///   .email(email, '邮箱')
///   .phone(phone, '手机号')
///   .minLength(password, 6, '密码')
///   .validate();
/// if (!result.isValid) {
///   print(result.errors);  // ['请输入姓名', '邮箱格式不正确']
/// }
/// ```
class Validator {
  final List<String> _errors = [];

  /// 获取所有错误信息。
  List<String> get errors => List.unmodifiable(_errors);

  /// 是否通过校验。
  bool get isValid => _errors.isEmpty;

  /// 是否未通过校验。
  bool get isInvalid => _errors.isNotEmpty;

  /// 重置校验器。
  void reset() => _errors.clear();

  /// 必填校验。
  Validator required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      _errors.add(
        i18n('validate.required', '请输入 @name', params: {'name': fieldName}),
      );
    }
    return this;
  }

  /// 邮箱格式校验。
  Validator email(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return this;
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) {
      _errors.add(
        i18n('validate.email', '@name 邮箱格式错误', params: {"name": fieldName}),
      );
    }
    return this;
  }

  /// 手机号格式校验（中国大陆 11 位）。
  Validator phone(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return this;
    final regex = RegExp(r'^1[3-9]\d{9}$');
    if (!regex.hasMatch(value.trim())) {
      _errors.add(
        i18n('validate.phone', '@name 手机格式错误', params: {'name': fieldName}),
      );
    }
    return this;
  }

  /// 验证用户输入的 [pattern] 是否为一个有效的正则表达式；注意跟原始字符串的区别
  Validator regexPattern(String pattern, String fileName) {
    if ((pattern.startsWith('r"') && pattern.endsWith('"')) ||
        (pattern.startsWith("r'") && pattern.endsWith("'"))) {
    } else {
      _errors.add(
        i18n(
          'validate.pattern',
          '不是一个有效的正则表达式:@name',
          params: {'name': fileName},
        ),
      );
    }
    return this;
  }

  /// 最小长度校验。
  Validator minLength(String? value, int min, String fieldName) {
    if (value == null) return this;
    if (value.length < min) {
      _errors.add(
        i18n(
          'validate.minLength',
          '@name 不能少于 @value 个字符',
          params: {'name': fieldName, 'value': min},
        ),
      );
    }
    return this;
  }

  /// 最大长度校验。
  Validator maxLength(String? value, int max, String fieldName) {
    if (value == null) return this;
    if (value.length > max) {
      _errors.add(
        i18n(
          'validate.maxLength',
          '@name 不能少于 @value 个字符',
          params: {'name': fieldName, 'value': max},
        ),
      );
    }
    return this;
  }

  /// 数字范围校验。
  Validator range(num? value, num min, num max, String fieldName) {
    if (value == null) return this;
    if (value < min || value > max) {
      _errors.add(
        i18n(
          'validate.range',
          '@name 必须在 @min 到 @max 之间',
          params: {'name': fieldName, 'min': min, 'max': max},
        ),
      );
    }
    return this;
  }

  /// 正则匹配校验。
  Validator matches(String? value, RegExp regex, String message) {
    if (value == null || value.trim().isEmpty) return this;
    if (!regex.hasMatch(value.trim())) {
      _errors.add(message);
    }
    return this;
  }

  /// 自定义校验。
  Validator check(bool condition, String message) {
    if (!condition) _errors.add(message);
    return this;
  }

  /// 执行所有已添加的校验并返回结果。
  ValidationResult validate() {
    if (isValid) return ValidationResult._valid();
    return ValidationResult._invalid(List.unmodifiable(_errors));
  }
}

/// 校验结果。
class ValidationResult {
  final List<String> errors;

  const ValidationResult._valid() : errors = const [];

  const ValidationResult._invalid(this.errors);

  bool get isValid => errors.isEmpty;
  bool get isInvalid => errors.isNotEmpty;

  @override
  String toString() => isValid
      ? i18n('valid', '验证通过')
      : i18n('invalid', '验证失败:@reason', params: {'reason': errors.toString()});
}
