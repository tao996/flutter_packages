import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 单行文本输入组件 - TextFormField 的封装，统一 OutlineInputBorder 样式。
class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? helperText;
  final bool isRequired;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLength;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const MyTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.helperText,
    this.isRequired = false,
    this.readOnly = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.maxLength,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator ??
          (isRequired
              ? (v) => (v == null || v.trim().isEmpty) ? '$labelText不能为空' : null
              : null),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}

/// 表单标签组件 - 支持必填标记。
///
/// 使用方式:
/// ```dart
/// MyInputLabel(label: 'Username', isRequired: true)
/// MyInputLabel(label: 'Email')
/// ```
class MyInputLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const MyInputLabel({
    super.key,
    required this.label,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = Text(label);
    if (isRequired) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.circle,
            size: 6,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 4),
          child,
        ],
      );
    }
    return child;
  }
}

/// 多行文本输入组件 - TextFormField 的封装。
class MyTextArea extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? helperText;
  final int maxLines;

  const MyTextArea({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.helperText,
    this.maxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }
}
