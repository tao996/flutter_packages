import 'package:flutter/material.dart';
import 'package:tao996/tao996.dart';

/// 表单辅助工具类 - 提供常用表单组件的快捷方法。
///
/// 使用方式:
/// ```dart
/// FormHelper.select(
///   label: 'Category',
///   items: [KV(label: 'Tech', value: 'tech')],
///   value: 'tech',
///   onChanged: (value) => print(value),
/// )
/// ```
class MyFormHelper {
  MyFormHelper._();

  /// 生成表单 key，用于表单验证。
  ///
  /// 使用方式:
  /// ```dart
  /// final formKey = FormHelper.formKey();
  /// if (formKey.currentState!.validate()) {
  ///   // 验证通过
  /// }
  /// ```
  static GlobalKey<FormState> formKey() {
    return GlobalKey<FormState>();
  }

  /// 下拉选择框。
  ///
  /// 使用方式:
  /// ```dart
  /// FormHelper.select<String>(
  ///   label: 'Category',
  ///   items: [
  ///     KV(label: 'Technology', value: 'tech'),
  ///     KV(label: 'Science', value: 'science'),
  ///   ],
  ///   value: selectedValue,
  ///   onChanged: (value) => setState(() => selectedValue = value),
  ///   isRequired: true,
  /// )
  /// ```
  static Widget select<T>({
    required String label,
    required List<KV<T>> items,
    required ValueChanged<T> onChanged,
    T? value,
    String? hintText,
    String? helperText,
    bool isRequired = false,
    String? Function(T?)? validator,
  }) {
    if (value != null) {
      final values = items.map((kv) => kv.value).toList();
      if (!values.contains(value)) {
        value = null;
      }
    }

    return DropdownButtonFormField<T>(
      isExpanded: true,
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        border: const OutlineInputBorder(),
      ),
      selectedItemBuilder: (BuildContext context) {
        return items.map<Widget>((KV item) {
          return Text(item.label, overflow: TextOverflow.ellipsis, maxLines: 1);
        }).toList();
      },
      items: items.map((KV kv) {
        return DropdownMenuItem<T>(
          value: kv.value,
          child: Text(kv.label, softWrap: true),
        );
      }).toList(),
      onChanged: (v) {
        if (v != null) {
          onChanged(v);
        }
      },
      hint: hintText != null ? Text(hintText, softWrap: true) : null,
      validator: validator,
    );
  }

  /// FilterChip 复选按钮组（水平布局，自动换行）。
  ///
  /// 使用方式:
  /// ```dart
  /// FormHelper.filterChipCheckbox<String>(
  ///   items: [
  ///     KV(label: 'Tag1', value: 'tag1'),
  ///     KV(label: 'Tag2', value: 'tag2'),
  ///   ],
  ///   values: ['tag1'],
  ///   onSelectionChanged: (selected, item) {
  ///     print('$item selected: $selected');
  ///   },
  /// )
  /// ```
  static Widget filterChipCheckbox<T>({
    required List<KV<T>> items,
    required void Function(bool selected, T item) onSelectionChanged,
    List<T>? values,
    Widget? trailing,
  }) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        ...items.map((item) {
          final isSelected = values?.contains(item.value) ?? false;
          return FilterChip(
            label: Text(item.label),
            selected: isSelected,
            onSelected: (selected) => onSelectionChanged(selected, item.value),
          );
        }),
        ?trailing,
      ],
    );
  }

  /// 单选 FilterChip 按钮组。
  ///
  /// 使用方式:
  /// ```dart
  /// FormHelper.oneFilterChip<String>(
  ///   items: [KV(label: 'Option 1', value: 'opt1')],
  ///   value: selectedValue,
  ///   label: 'Choose one',
  ///   onSelectionChanged: (item) => setState(() => selectedValue = item),
  /// )
  /// ```
  static Widget oneFilterChip<T>({
    required List<KV<T>> items,
    required void Function(T? item) onSelectionChanged,
    T? value,
    String? label,
    InputDecoration? decoration,
    bool isRequired = true,
  }) {
    final child = filterChipCheckbox<T>(
      items: items,
      onSelectionChanged: (selected, item) {
        if (selected) {
          onSelectionChanged(item);
        } else if (!isRequired) {
          onSelectionChanged(null);
        }
      },
      values: value == null ? null : [value],
    );

    if (label != null && label.isNotEmpty) {
      return inputDecoration(
        label,
        child,
        decoration: decoration,
        isRequired: isRequired,
      );
    }
    return child;
  }

  /// SegmentedButton 分段按钮。
  ///
  /// 使用方式:
  /// ```dart
  /// FormHelper.segmentedButton<String>(
  ///   items: [KV(label: 'Daily', value: 'daily')],
  ///   values: ['daily'],
  ///   onSelectionChanged: (selected) => print(selected),
  /// )
  /// ```
  static Widget segmentedButton<T>({
    required List<KV<T>> items,
    required void Function(Set<T> items) onSelectionChanged,
    required List<T> values,
    bool multiSelectionEnabled = false,
    bool emptySelectionAllowed = true,
  }) {
    return SegmentedButton<T>(
      multiSelectionEnabled: multiSelectionEnabled,
      emptySelectionAllowed: emptySelectionAllowed,
      segments: items.map((kv) {
        return ButtonSegment<T>(value: kv.value, label: Text(kv.label));
      }).toList(),
      selected: values.toSet(),
      onSelectionChanged: onSelectionChanged,
    );
  }

  /// 单选分段按钮。
  ///
  /// 使用方式:
  /// ```dart
  /// FormHelper.oneSegmentedButton<String>(
  ///   items: [KV(label: 'Option A', value: 'a')],
  ///   value: 'a',
  ///   label: 'Choose',
  ///   onSelectionChanged: (value) => print(value),
  /// )
  /// ```
  static Widget oneSegmentedButton<T>({
    required List<KV<T>> items,
    required void Function(T value) onSelectionChanged,
    T? value,
    String? label,
    bool isRequired = false,
  }) {
    final child = segmentedButton<T>(
      items: items,
      onSelectionChanged: (data) {
        if (data.isNotEmpty) {
          onSelectionChanged(data.first);
        }
      },
      values: value == null ? [] : [value],
    );

    if (label != null && label.isNotEmpty) {
      return inputDecoration(label, child, isRequired: isRequired);
    }
    return child;
  }

  /// InputDecorator 包装器，为任意 Widget 添加标签和边框。
  ///
  /// 使用方式:
  /// ```dart
  /// FormHelper.inputDecoration(
  ///   'Label',
  ///   MyCustomWidget(),
  ///   isRequired: true,
  /// )
  /// ```
  static Widget inputDecoration(
    String label,
    Widget child, {
    InputDecoration? decoration,
    bool isRequired = false,
  }) {
    return InputDecorator(
      decoration:
          decoration ??
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      child: child,
    );
  }
}
