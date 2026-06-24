import 'package:flutter/material.dart';
import 'package:tao996/tao996.dart';

/// 字体选择器。
class FontHelper {
  const FontHelper();

  /// 显示字体选择对话框。
  void showFontPickerDialog(
    BuildContext context, {
    required List<String> fonts,
    void Function(String)? onChange,
  }) {
    final searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final filtered = searchController.text.isEmpty
              ? fonts
              : fonts
                    .where(
                      (f) => f.toLowerCase().contains(
                        searchController.text.toLowerCase(),
                      ),
                    )
                    .toList();
          return AlertDialog(
            title: Text(i18n('fontPickerTitle', '选择系统字体')),
            content: SizedBox(
              width: 400,
              height: 500,
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: i18n('fontPickerHint', '搜索字体名称...'),
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => ListTile(
                        title: Text(filtered[i]),
                        subtitle: Text(
                          i18n(
                            'fontPickerPreview',
                            '预览: The quick brown fox 123',
                          ),
                          style: TextStyle(
                            fontFamily: filtered[i],
                            fontSize: 14,
                          ),
                        ),
                        onTap: () {
                          onChange?.call(filtered[i]);
                          Navigator.pop(ctx);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(i18n('cancel', '取消')),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 构建字体选择列表项。
  Widget buildTile(
    BuildContext context,
    String fontFamily, {
    void Function(String)? onChange,
  }) {
    return ListTile(
      title: Text(i18n('fontPickerStyle', '字体样式')),
      subtitle: Text(
        fontFamily.isEmpty ? i18n('fontPickerSystem', '默认系统字体') : fontFamily,
        style: TextStyle(fontFamily: fontFamily),
      ),
      trailing: const Icon(Icons.font_download_outlined),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      onTap: () => showFontPickerDialog(context, fonts: [], onChange: onChange),
    );
  }
}
