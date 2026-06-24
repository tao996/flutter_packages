/// 数据模型基类 — 所有数据库模型的基类。
///
/// 提供 id, createdAt, updatedAt, deletedAt 四个标准字段，
/// 以及 JSON 序列化、复制等方法。
class IModel {
  /// 主键 ID。
  int id;

  /// 创建时间（ISO-8601 字符串）。
  String createdAt;

  /// 更新时间（ISO-8601 字符串）。
  String updatedAt;

  /// 删除时间（软删除标记，null 表示未删除）。
  String? deletedAt;

  IModel({this.id = 0, String? createdAt, String? updatedAt, this.deletedAt})
    : createdAt = createdAt ?? _now(),
      updatedAt = updatedAt ?? _now();

  /// 从 JSON Map 创建。
  IModel.fromJson(Map<String, dynamic> json)
    : id = (json['id'] as num?)?.toInt() ?? 0,
      createdAt = json['createdAt'] as String? ?? _now(),
      updatedAt = json['updatedAt'] as String? ?? _now(),
      deletedAt = json['deletedAt'] as String?;

  /// 转为 JSON Map。
  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'deletedAt': deletedAt,
  };

  /// 复制并更新部分字段。
  IModel copyWith({
    int? id,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) => IModel(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt ?? this.deletedAt,
  );

  /// 从另一个模型复制基础字段。
  void copyBaseDataFrom(IModel? other) {
    if (other == null) return;
    id = other.id;
    createdAt = other.createdAt;
    updatedAt = other.updatedAt;
    deletedAt = other.deletedAt;
  }

  /// 是否已软删除。
  bool get isDeleted => deletedAt != null;

  /// 标记为已删除。
  void markDeleted() => deletedAt = _now();

  /// 标记为未删除。
  void markNotDeleted() => deletedAt = null;

  static String _now() => DateTime.now().toIso8601String();

  @override
  String toString() => 'IModel(id: $id)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is IModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
