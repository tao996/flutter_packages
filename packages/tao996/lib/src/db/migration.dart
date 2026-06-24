import 'repository.dart';

/// 数据库迁移模块接口。
///
/// 每个模块实现此接口，定义自己的建表和升级逻辑。
///
/// 使用方式:
/// ```dart
/// final migrator = Migrator(db, [
///   BookMigration(),
///   MemberMigration(),
/// ], targetVersion: 2);
/// await migrator.execute();
/// ```
abstract class Migration {
  /// 模块标识（唯一）。
  String get id;

  /// 当前版本号。
  int get version;

  /// 首次创建时调用。
  void onCreate(IDatabaseService db);

  /// 从 [installVersion] 升级到当前版本时调用。
  void onUpgrade(IDatabaseService db, int installVersion);
}

/// 迁移执行器。
class Migrator {
  final IDatabaseService _db;
  final List<Migration> _modules;
  final int targetVersion;

  Migrator(this._db, this._modules, {this.targetVersion = 1});

  /// 执行所有迁移。
  Future<void> execute() async {
    // 创建版本记录表
    await _ensureVersionTable();

    for (final module in _modules) {
      final installedVersion = await _getInstalledVersion(module.id);

      if (installedVersion == null) {
        // 首次安装
        module.onCreate(_db);
        await _setVersion(module.id, module.version);
      } else if (installedVersion < module.version) {
        // 需要升级
        module.onUpgrade(_db, installedVersion);
        await _setVersion(module.id, module.version);
      }
      // 已是最新，跳过
    }
  }

  Future<void> _ensureVersionTable() async {
    try {
      await _db.execute('''
        CREATE TABLE IF NOT EXISTS _migrations (
          module_id TEXT PRIMARY KEY,
          version INTEGER NOT NULL,
          applied_at TEXT NOT NULL
        )
      ''');
    } catch (_) {
      // 表已存在
    }
  }

  Future<int?> _getInstalledVersion(String moduleId) async {
    final rows = await _db.query(
      'SELECT version FROM _migrations WHERE module_id = ?',
      [moduleId],
    );
    if (rows.isEmpty) return null;
    return (rows.first['version'] as num?)?.toInt();
  }

  Future<void> _setVersion(String moduleId, int version) async {
    final now = DateTime.now().toIso8601String();
    await _db.execute(
      'INSERT OR REPLACE INTO _migrations (module_id, version, applied_at) VALUES (?, ?, ?)',
      [moduleId, version, now],
    );
  }
}
