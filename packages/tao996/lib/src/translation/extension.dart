import 'translation.dart';

String get iInsert => i18n('insert', '添加');
String get iUpdate => i18n('update', '更新');
String get iDelete => i18n('delete', '删除');

extension I18nExt on String {
  // 优化后：'xxx'.mustRequired -> 'mustRequired'.trParams({'title': 'xxx'.tr})

  // 校验类：结构化处理
  String get mustRequired =>
      i18n('mustRequired', '@title不能为空', params: {'title': this});
  String get mustString =>
      i18n('mustString', '@title必须是字符串', params: {'title': this});
  String get mustInteger =>
      i18n('mustInteger', '@title必须是整数', params: {'title': this});
  String get mustBoolean =>
      i18n('mustBoolean', '@title必须是布尔值', params: {'title': this});
  String get mustArray =>
      i18n('mustArray', '@title必须是数组', params: {'title': this});
  String get mustObject =>
      i18n('mustObject', '@title必须是对象', params: {'title': this});
  String mustLessThen(dynamic value) => i18n(
    'mustLessThen',
    '@title必须小于@value',
    params: {'title': this, 'value': value},
  );
  String mustGreatThen(dynamic value) => i18n(
    'mustGreatThen',
    '@title必须大于@value',
    params: {'title': this, 'value': value},
  );
  String mustNotLessThen(dynamic value) => i18n(
    'mustNotLessThen',
    '@title不能小于@value',
    params: {'title': this, 'value': value},
  );
  String mustNotGreatThen(dynamic value) => i18n(
    'mustNotGreatThen',
    '@title不能大于@value',
    params: {'title': this, 'value': value},
  );
  String get mustSelected =>
      i18n('mustSelected', '必须选择一个@title', params: {'title': this});
  String get isRepeat => i18n('isRepeat', '重复的@title', params: {'title': this});
  String get errorPattern =>
      i18n('errorPattern', '@title格式错误', params: {'title': this});
  String get isExist => i18n('isExist', '@title已存在', params: {'title': this});
  String get isNotExist =>
      i18n('isNotExist', '@title不存在', params: {'title': this});
  String get noRecordFound =>
      i18n('noRecordFound', '没有找到符合条件的@title', params: {'title': this});
  String get noRecord => i18n('noRecord', '暂无@title', params: {'title': this});

  // 操作类：通过占位符解决词序问题
  String get toInsert => i18n('toInsert', '添加@title', params: {'title': this});
  String get toEdit => i18n('toEdit', '编辑@title', params: {'title': this});
  String get toDelete => i18n('toDelete', '删除@title', params: {'title': this});
  String get toManage => i18n('toManage', '@title管理', params: {'title': this});
  String get toList => i18n('toList', '@title列表', params: {'title': this});
  String get toSearch => i18n('toSearch', '搜索@title', params: {'title': this});
  String get toSelect => i18n('toSelect', '选择@title', params: {'title': this});
  String get toImport => i18n('toImport', '导入@title', params: {'title': this});
  //表单类
  String get inputHint =>
      i18n('inputHint', '请输入@title', params: {'title': this});

  // 结果类：
  String get insertSuccess =>
      i18n('insertSuccess', '添加@title成功', params: {'title': this});
  String get insertFailed =>
      i18n('insertFailed', '添加@title失败', params: {'title': this});
  String get saveSuccess =>
      i18n('saveSuccess', '保存@title成功', params: {'title': this});
  String get saveFailed =>
      i18n('saveFailed', '保存@title失败', params: {'title': this});
  String get editSuccess =>
      i18n('editSuccess', '编辑@title成功', params: {'title': this});
  String get editFailed =>
      i18n('editFailed', '编辑@title失败', params: {'title': this});
  String get updateSuccess =>
      i18n('updateSuccess', '更新@title成功', params: {'title': this});
  String get updateFailed =>
      i18n('updateFailed', '更新@title失败', params: {'title': this});
  String get deleteSuccess =>
      i18n('deleteSuccess', '删除@title成功', params: {'title': this});
  String get deleteFailed =>
      i18n('deleteFailed', '删除@title失败', params: {'title': this});
}
