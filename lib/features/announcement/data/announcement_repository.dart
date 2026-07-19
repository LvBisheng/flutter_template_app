import '../domain/announcement.dart';
import 'announcement_api.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 公告仓库抽象。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【为什么定义抽象接口？】
/// 1. 解耦：Controller 依赖抽象，不依赖具体实现
/// 2. 可测试：测试时可以替换为 Mock Repository
/// 3. 可扩展：未来可以有不同的实现（本地缓存、多数据源等）
///
abstract class AnnouncementRepository {
  /// 获取公告列表。
  Future<List<Announcement>> fetchList();
}

/// ─────────────────────────────────────────────────────────────────────
/// 公告仓库实现。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【Repository 实现职责】
/// 调用 API 获取 Entity 列表（转换已在 API 层完成）。
///
class AnnouncementRepositoryImpl implements AnnouncementRepository {
  const AnnouncementRepositoryImpl(this._api);

  final AnnouncementApi _api;

  @override
  Future<List<Announcement>> fetchList() => _api.fetchList();
}
