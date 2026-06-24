class ArrayUtil {
  const ArrayUtil();

  /// 求交集 (Intersection)
  List<T> intersection<T>(List<T> a, List<T> b) {
    return a.toSet().intersection(b.toSet()).toList();
  }

  /// 批量对比 (Batch Compare): 批量对比两个列表的元素，并返回插入、删除、更新的元素
  ///
  /// [compare]: 比较函数，返回 true 表示两个元素相等
  ///
  /// [insertion]: 新增元素列表，在 [b] 中存在，但不在 [a] 中
  ///
  /// [deletion]: 删除元素列表, 在 [a] 中存在，但不在 [b] 中
  ///
  /// [update]: 更新元素列表, 在 [a] 中存在，[b] 中存在，取的是 [b] 中的新元素
  void deepCompare<T>(
    List<T> a,
    List<T> b,
    bool Function(T a, T b) compare,
    void Function(List<T> items) insertion,
    void Function(List<T> items) deletion,
    void Function(List<T> items) update,
  ) {
    final insertions = <T>[];
    final deletions = <T>[];
    final updates = <T>[];
    final matchedInB = List.filled(b.length, false);

    for (final itemA in a) {
      var found = false;
      for (var i = 0; i < b.length; i++) {
        if (!matchedInB[i] && compare(itemA, b[i])) {
          found = true;
          matchedInB[i] = true;
          updates.add(b[i]);
          break;
        }
      }
      if (!found) deletions.add(itemA);
    }

    for (var i = 0; i < b.length; i++) {
      if (!matchedInB[i]) insertions.add(b[i]);
    }

    insertion(insertions);
    deletion(deletions);
    update(updates);
  }

  /// 深层交集
  List<T> deepIntersection<T>(
    List<T> a,
    List<T> b,
    bool Function(T a, T b) compare,
  ) {
    final result = <T>[];
    for (final itemA in a) {
      for (final itemB in b) {
        if (compare(itemA, itemB)) {
          var alreadyInResult = false;
          for (final resItem in result) {
            if (compare(resItem, itemA)) {
              alreadyInResult = true;
              break;
            }
          }
          if (!alreadyInResult) result.add(itemA);
          break;
        }
      }
    }
    return result;
  }

  /// 求并集 (Union)
  List<T> union<T>(List<T> a, List<T> b) {
    return a.toSet().union(b.toSet()).toList();
  }

  /// 求差集 (Difference)
  List<T> difference<T>(List<T> a, List<T> b) {
    return a.toSet().difference(b.toSet()).toList();
  }

  /// 深层差集 (Deep Difference): 返回在 [a] 中存在，但在 [b] 中不存在的元素
  ///
  /// [compare]: 比较函数，返回 true 表示两个元素相等
  ///
  /// 注意：结果列表会自动去重，避免重复元素
  List<T> deepDifference<T>(
    List<T> a,
    List<T> b,
    bool Function(T a, T b) compare,
  ) {
    final result = <T>[];
    final matchedInB = List.filled(b.length, false);

    for (final itemA in a) {
      var found = false;
      for (var i = 0; i < b.length; i++) {
        if (!matchedInB[i] && compare(itemA, b[i])) {
          found = true;
          matchedInB[i] = true;
          break;
        }
      }
      if (!found) {
        var alreadyInResult = false;
        for (final resItem in result) {
          if (compare(resItem, itemA)) {
            alreadyInResult = true;
            break;
          }
        }
        if (!alreadyInResult) result.add(itemA);
      }
    }
    return result;
  }

  List<T> unique<T>(Iterable<T> list) => list.toSet().toList();

  /// 降维 (Flatten)
  List<T> flatten<T>(List<List<T>> list) => list.expand((i) => i).toList();
}
