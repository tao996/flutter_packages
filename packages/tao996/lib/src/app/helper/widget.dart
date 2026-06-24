import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tao996/tao996.dart';

class WidgetHelper {
  const WidgetHelper();

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
  Widget avatar({
    String? logoPath,
    String? name,
    bool useLogo = true,
    double radius = 18,
    IconData? icon,
  }) {
    return MyAvatar(
      logoPath: logoPath,
      name: name,
      useLogo: useLogo,
      radius: radius,
      icon: icon,
    );
  }

  Widget button({
    Key? key,
    String? text,
    Widget? child,
    VoidCallback? onPressed,
    Widget? icon,
    MyButtonType? type,
    double? width,
    double? height,
    Color? backgroundColor,
    Color? foregroundColor,
    String? tooltip,
    bool loading = false,
    bool enabled = true,
    MyButtonStatus status = MyButtonStatus.primary,
    double borderRadius = 4,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
  }) {
    return MyButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      type: type,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      tooltip: tooltip,
      loading: loading,
      enabled: enabled,
      status: status,
      borderRadius: borderRadius,
      padding: padding,
      child: child,
    );
  }

  Widget saveButton({
    Key? key,
    String? label,
    VoidCallback? onPressed,
    bool loading = false,
  }) {
    return MySaveButton(
      key: key,
      label: label,
      onPressed: onPressed,
      loading: loading,
    );
  }

  Widget cancelButton({
    Key? key,
    VoidCallback? onPressed,
    bool isBack = false,
  }) {
    return MyCancelButton(key: key, isBack: isBack, onPressed: onPressed);
  }

  Widget deleteButton({
    Key? key,
    VoidCallback? onPressed,
    bool confirm = true,
  }) {
    return MyDeleteButton(key: key, onPressed: onPressed, confirm: confirm);
  }

  Widget deleteIconButton({
    Key? key,
    VoidCallback? onPressed,
    String? tooltip,
  }) {
    return MyDeleteIconButton(key: key, onPressed: onPressed, tooltip: tooltip);
  }

  Widget insertButton({Key? key, String? label, VoidCallback? onPressed}) {
    return MyInsertButton(key: key, label: label, onPressed: onPressed);
  }

  Widget insertIconButton({
    Key? key,
    VoidCallback? onPressed,
    String? tooltip,
  }) {
    return MyAddIconButton(key: key, onPressed: onPressed, tooltip: tooltip);
  }

  Widget editButton({Key? key, String? label, VoidCallback? onPressed}) {
    return MyEditButton(key: key, label: label, onPressed: onPressed);
  }

  Widget editIconButton({Key? key, VoidCallback? onPressed, String? tooltip}) {
    return MyEditIconButton(key: key, onPressed: onPressed, tooltip: tooltip);
  }

  Widget menuButtons({Key? key, required List<List<MyMenuButtonItem>> items}) {
    return MyMenuButtons(key: key, items: items);
  }

  Widget qrcodeIconButton({
    Key? key,
    required void Function(String?) onChange,
  }) {
    return MyQrcodeIconButton(key: key, onChange: onChange);
  }

  Widget customTabBar({
    Key? key,
    required RxInt activeIndex,
    required void Function(int index) onChange,
    required List<MyCustomTabBarItem> children,
    void Function(int index)? onDoubleTap,
    Color? notebookBgColor,
    VoidCallback? onInsert,
    double height = 50,
    MyCustomTabBarStyle style = MyCustomTabBarStyle.horizontal,
  }) {
    return MyCustomTabBar(
      key: key,
      activeIndex: activeIndex,
      onChange: onChange,
      children: children,
      onDoubleTap: onDoubleTap,
      notebookBgColor: notebookBgColor,
      onInsert: onInsert,
      height: height,
      style: style,
    );
  }

  Widget empty({
    Key? key,
    EmptyType type = EmptyType.noData,
    String? message,
    Widget? icon,
    VoidCallback? onRetry,
    String? retryText,
  }) {
    return EmptyView(
      key: key,
      type: type,
      message: message,
      icon: icon,
      onRetry: onRetry,
      retryText: retryText,
    );
  }

  Widget emptyNoData({
    Key? key,
    String? message,
    Widget? icon,
    VoidCallback? onRetry,
    String? retryText,
  }) {
    return EmptyView.noData(
      key: key,
      message: message,
      icon: icon,
      onRetry: onRetry,
      retryText: retryText,
    );
  }

  Widget emptyNoNetwork({
    Key? key,
    String? message,
    Widget? icon,
    VoidCallback? onRetry,
    String? retryText,
  }) {
    return EmptyView.noNetwork(
      key: key,
      message: message,
      icon: icon,
      onRetry: onRetry,
      retryText: retryText,
    );
  }

  Widget emptyNoPermission({
    Key? key,
    String? message,
    Widget? icon,
    VoidCallback? onRetry,
    String? retryText,
  }) {
    return EmptyView.noPermission(
      key: key,
      message: message,
      icon: icon,
      onRetry: onRetry,
      retryText: retryText,
    );
  }

  /// 空状态布局，会占据整个空余的屏幕（自动根据宽度高度适配）
  Widget emptyView({
    Key? key,
    required String titleText,
    String? descText,
    String? buttonText,
    void Function()? onPressed,
  }) {
    return MyEmptyStateLayout(
      key: key,
      titleText: titleText,
      descText: descText,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  /// 网络复选按钮组
  /// [crossAxisCount] 列数，默认为 3
  /// [horizontal] 水平内边距
  Widget gridCheckbox({
    Key? key,
    required List<String> items,
    required ValueChanged<List<String>> onSelectionChanged,
    List<String>? values,
    int crossAxisCount = 3,
    double horizontal = 18,
  }) {
    return GridCheckbox(
      key: key,
      items: items,
      values: values,
      onSelectionChanged: onSelectionChanged,
      crossAxisCount: crossAxisCount,
      horizontal: horizontal,
    );
  }

  Widget animatedIcon({
    Key? key,
    IconData icon = Icons.refresh,
    bool isLoading = false,
    double size = 18,
    Color? color,
  }) {
    return MyAnimatedIcon(
      key: key,
      icon: icon,
      isLoading: isLoading,
      size: size,
      color: color,
    );
  }

  /// 图标/SVG 组件 - 支持 IconData、Asset、本地文件、网络图片。
  ///
  /// 使用方式:
  /// ```dart
  /// // IconData
  /// MyIconSvg(Icons.home, size: 24)
  ///
  /// // Asset SVG
  /// MyIconSvg('assets/icons/logo.svg', size: 24)
  ///
  /// // 本地文件
  /// MyIconSvg('/path/to/icon.svg', size: 24)
  ///
  /// // 网络图片
  /// MyIconSvg('https://example.com/icon.svg', size: 24)
  ///
  /// // 短文本
  /// MyIconSvg('AB', size: 24)
  /// ```
  Widget iconSvg({
    Key? key,
    required dynamic data,
    Color? color,
    int textLength = 7,
    double size = 24,
    BoxFit boxFit = BoxFit.cover,
  }) {
    return MyIconSvg(
      data,
      key: key,
      size: size,
      color: color,
      textLength: textLength,
      boxFit: boxFit,
    );
  }

  /// 具有缓存功能的图片组件，支持网络图片、本地图片、资源图片。
  /// [enabledTap] 是否启用点击事件，如果[onTap] 为空，则是打开图片
  Widget image({
    Key? key,
    required dynamic data,
    VoidCallback? onTap,
    double? size,
    bool enabledTap = true,
  }) {
    return MyImageCache(
      key: key,
      data: data,
      onTap: onTap,
      enabledTap: enabledTap,
      size: size,
    );
  }

  /// 网络图片（带缓存、占位符、错误处理）。
  ///
  /// 使用 Flutter 内置 Image.network，在测试环境可无缝替换。
  Widget networkImage({
    Key? key,
    String? url,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    BorderRadius? borderRadius,
  }) {
    return MyNetworkImage(
      key: key,
      url: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
      borderRadius: borderRadius,
    );
  }

  Widget input({
    Key? key,
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    String? helperText,
    bool isRequired = false,
    bool readOnly = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    int? maxLength,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    return MyTextField(
      key: key,
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      isRequired: isRequired,
      readOnly: readOnly,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      maxLength: maxLength,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
    );
  }

  Widget inputLabel({
    Key? key,
    required String label,
    bool isRequired = false,
  }) {
    return MyInputLabel(key: key, label: label, isRequired: isRequired);
  }

  Widget textarea({
    Key? key,
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    String? helperText,
    int maxLines = 3,
  }) {
    return MyTextArea(
      key: key,
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      maxLines: maxLines,
    );
  }

  /// 日期选择输入框。
  ///
  /// [labelText] 标签文本，默认为 '选择日期'
  Widget dateInput({
    Key? key,
    required DateTime? initialDate,
    required Function(DateTime?) onDateSelected,
    String? labelText,
    String? hintText,
  }) {
    return FakeDateInput(
      key: key,
      labelText: labelText ?? i18n('datePicker', '选择日期'),
      hintText: hintText,
      initialDate: initialDate,
      onDateSelected: onDateSelected,
    );
  }

  /// 时间选择输入框。
  ///
  /// [labelText] 标签文本，默认为 '选择时间'
  Widget timeInput({
    Key? key,
    required DateTime? initTime,
    required Function(DateTime?) onTimeSelected,
    String? labelText,
    String? hintText,
  }) {
    return FakeTimeInput(
      key: key,
      labelText: labelText ?? i18n('timePicker', '选择时间'),
      onTimeSelected: onTimeSelected,
      hintText: hintText,
      initTime: initTime,
    );
  }

  /// 卡片工具 — 带圆角和阴影的 Card 封装。
  Widget card(Widget child, {bool fullWidth = true}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: fullWidth
            ? SizedBox(width: double.infinity, child: child)
            : child,
      ),
    );
  }

  Widget miniColumn(
    List<Widget> children, {
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    double spacing = 0,
  }) {
    return MyLayout.miniColumn(
      children,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      spacing: spacing,
    );
  }

  Widget miniRow(
    List<Widget> children, {
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    double spacing = 0,
  }) {
    return MyLayout.miniRow(
      children,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      spacing: spacing,
    );
  }

  /// 列表多选组件 - 支持泛型的复选框列表。
  ///
  /// 使用方式:
  /// ```dart
  /// ListCheckbox<String>(
  ///   items: [
  ///     KV(label: 'Apple', value: 'apple'),
  ///     KV(label: 'Banana', value: 'banana'),
  ///   ],
  ///   values: ['apple'],
  ///   onSelectionChanged: (selected) {
  ///     print('Selected: $selected');
  ///   },
  /// )
  /// ```
  Widget listCheckbox<T>({
    Key? key,
    required List<KV<T>> items,
    List<T>? values,
    ValueChanged<List<T>>? onSelectionChanged,
    bool dense = false,
  }) {
    return ListCheckbox<T>(
      key: key,
      items: items,
      values: values,
      onSelectionChanged: onSelectionChanged,
      dense: dense,
    );
  }

  Widget loading() {
    return const MyLoading();
  }

  /// 放在 AppBar bottom 中的加载进度条。
  PreferredSizeWidget? appBarLoading(RxBool isLoading) {
    return myAppBarLoading(isLoading);
  }

  /// 二维码生成视图
  Widget qrcode({
    Key? key,
    required String data,
    double size = 200,
    Color backgroundColor = Colors.white,
    Color foregroundColor = Colors.black,
    Widget? embeddedImage,
    double embeddedImageSize = 40,
  }) {
    return QRCodeView(
      key: key,
      data: data,
      size: size,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      embeddedImage: embeddedImage,
      embeddedImageSize: embeddedImageSize,
    );
  }

  /// 拖拽排序列表。
  Widget reorder<T>({
    Key? key,
    required RxList<T> items,
    required Widget Function(BuildContext context, int index) itemBuilder,
    Widget? emptyWidget,
    void Function(int oldIndex, int newIndex)? onReorder,
  }) {
    return MyReorder<T>(
      items,
      itemBuilder: itemBuilder,
      emptyWidget: emptyWidget,
      onReorder: onReorder,
    );
  }

  /// 集成 SafeArea 的页面骨架。
  /// [unfocusOnTap] 默认为 true，点击空白处时，会 unfocus 掉当前页面的焦点;
  /// [singleChildScrollView] 默认为 false
  Widget scaffold({
    Key? key,
    required Widget body,
    AppBar? appBar,
    Widget? drawer,

    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
    Widget? bottomSheet,
    Color? backgroudColor,
    bool useSafeArea = true,
    bool singleChildScrollView = false,
    bool unfocusOnTap = true,

    double? drawerEdgeDragWidthPercent,
    FloatingActionButtonLocation? floatingActionButtonLocation,
  }) {
    return MyScaffold(
      key: key,
      body: body,
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,

      backgroundColor: backgroudColor,
      useSafeArea: useSafeArea,
      singleChildScrollView: singleChildScrollView,
      unfocusOnTap: unfocusOnTap,

      drawerEdgeDragWidthPercent: drawerEdgeDragWidthPercent,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }

  Widget padding({
    Key? key,
    required Widget child,
    double? horizontal,
    double? vertical,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return MyPadding(
      key: key,
      horizontal: horizontal,
      vertical: vertical,
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: child,
    );
  }

  Widget searchInput({
    Key? key,
    required Function(String) onSearch,
    int debounceMs = 300,
    String? hintText,
    TextEditingController? controller,
  }) {
    return SearchInput(
      key: key,
      onSearch: onSearch,
      debounceMs: debounceMs,
      hintText: hintText,
      controller: controller,
    );
  }

  Widget separatorLine({Key? key}) {
    return MySeparatorLine(key: key);
  }

  /// 构建表格的快捷方法。
  ///
  /// 使用方式:
  /// ```dart
  /// myTableBuilder(
  ///   [
  ///     MyHeaderColumn(text: 'Name', flex: 2),
  ///     MyHeaderColumn(text: 'Age', width: 80),
  ///   ],
  ///   [
  ///     [Text('Alice'), Text('25')],
  ///     [Text('Bob'), Text('30')],
  ///   ],
  /// )
  /// ```
  Widget table({
    Key? key,
    required List<MyHeaderColumn> headers,
    required List<List<Widget>> rows,
    double dataRowHeight = 60,
    double? dataRowMaxHeight,
    double? dataRowMinHeight,
  }) {
    return MyTable(
      headers: headers.map((c) {
        return DataColumn(
          label: c.label ?? Text(c.text),
          columnWidth: c.width != null
              ? FixedColumnWidth(c.width!)
              : FlexColumnWidth(c.flex),
        );
      }).toList(),
      rows: rows.map((es) {
        return DataRow(cells: es.map((dc) => DataCell(dc)).toList());
      }).toList(),
      dataRowHeight: dataRowHeight,
      dataRowMaxHeight: dataRowMaxHeight,
      dataRowMinHeight: dataRowMinHeight,
      key: key,
    );
  }

  Widget h1(String title, {Color? color}) {
    return MyText.h1(title, color: color);
  }

  Widget h2(String title, {Color? color}) {
    return MyText.h2(title, color: color);
  }

  Widget h3(String title, {Color? color}) {
    return MyText.h3(title, color: color);
  }

  Widget h4(String title, {Color? color}) {
    return MyText.h4(title, color: color);
  }

  Widget h5(String title, {Color? color}) {
    return MyText.h5(title, color: color);
  }

  Widget h6(String title, {Color? color}) {
    return MyText.h6(title, color: color);
  }

  Widget placeholder(String title, {Color? color}) {
    return MyText.placeholder(title, color: color);
  }

  Widget bold(String title) {
    return MyText.bold(title);
  }

  Widget inkTitle(String title, VoidCallback onTap) {
    return MyText.inkTitle(title, onTap);
  }

  Widget sectionTitle(
    String title, {
    IconData? iconData,
    String? subTitle,
    Widget? trailing,
  }) {
    return MyText.sectionTitle(
      title,
      iconData: iconData,
      subTitle: subTitle,
      trailing: trailing,
    );
  }

  Widget listview(
    EasyRefreshController controller, {
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    Widget Function(BuildContext, int)? separatorBuilder,
    EdgeInsetsGeometry? padding,
  }) {
    return EasyRefresh.listView(
      controller,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder,
      padding: padding,
    );
  }

  Widget smartRefresherListView<T>(
    SmartRefresherController<T> controller, {
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    bool canLoadMore = true,
    Widget? empty,
    Widget Function(BuildContext, int)? separatorBuilder,
    EdgeInsetsGeometry? padding,
  }) {
    return MySmartRefresher.obxListView<T>(
      controller,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      canLoadMore: canLoadMore,
      empty: empty,
      separatorBuilder: separatorBuilder,
      padding: padding,
    );
  }
}
