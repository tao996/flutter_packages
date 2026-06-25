import 'package:flutter/material.dart';
import 'package:tao996/tao996.dart';

/// 搜索输入框（防抖、清除按钮）。
class SearchInput extends StatefulWidget {
  final Function(String) onSearch;
  final int debounceMs;
  final String? hintText;
  final TextEditingController? controller;

  const SearchInput({
    super.key,
    required this.onSearch,
    this.debounceMs = 300,
    this.hintText,
    this.controller,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late final TextEditingController _controller;
  late final DebounceFn _debounce;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _debounce = MyFnUtil.debounce(
      () => widget.onSearch(_controller.text),
      milliseconds: widget.debounceMs,
    );
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
    _debounce();
  }

  void _clear() {
    _controller.clear();
    widget.onSearch('');
  }

  @override
  void dispose() {
    _debounce.cancel();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText ?? i18n('search', '搜索'),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _hasText
            ? IconButton(icon: const Icon(Icons.clear), onPressed: _clear)
            : null,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }
}
