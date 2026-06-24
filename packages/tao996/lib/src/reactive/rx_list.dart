/// 响应式数组 — [RxList<T>]。
library;

import 'rx.dart';

/// 响应式数组，集合变异操作自动通知。
class RxList<T> extends Rx<List<T>> {
  RxList([List<T> initial = const []]) : super(List<T>.of(initial));

  /// 从已有列表创建。
  RxList.of(Iterable<T> initial) : super(List<T>.of(initial));

  /// 尾部追加一个元素。
  void add(T item) {
    value = [...value, item];
  }

  /// 批量追加。
  void addAll(Iterable<T> items) {
    value = [...value, ...items];
  }

  /// 移除指定索引元素。
  void removeAt(int index) {
    final list = List<T>.of(value);
    list.removeAt(index);
    value = list;
  }

  /// 在指定位置插入。
  void insert(int index, T item) {
    final list = List<T>.of(value);
    list.insert(index, item);
    value = list;
  }

  /// 移除满足条件的元素。
  void removeWhere(bool Function(T) predicate) {
    final list = List<T>.of(value);
    list.removeWhere(predicate);
    value = list;
  }

  /// 更新指定索引的值。
  void set(int index, T item) {
    final list = List<T>.of(value);
    list[index] = item;
    value = list;
  }

  /// 是否包含指定元素（通过 `==` 比较）。
  bool contains(T item) => value.contains(item);

  /// 查找满足条件的第一个索引，未找到返回 -1。
  int indexWhere(bool Function(T) predicate) => value.indexWhere(predicate);

  /// 过滤出满足条件的元素（返回新列表，不触发通知）。
  List<T> where(bool Function(T) predicate) => value.where(predicate).toList();

  /// 映射转换（返回新列表，不触发通知）。
  List<R> map<R>(R Function(T) mapper) => value.map(mapper).toList();

  /// 用新数组替换全部。
  void replaceAll(Iterable<T> items) {
    value = List<T>.of(items);
  }

  /// 强制通知监听者（值不变时手动触发 UI 刷新）。
  @override
  void refresh() {
    notifyListeners();
  }

  /// 清空列表。
  void clear() {
    value = [];
  }

  /// 当前长度。
  int get length => value.length;

  /// 按索引访问。
  T operator [](int index) => value[index];
}
