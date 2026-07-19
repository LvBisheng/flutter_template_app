import '../../../core/network/api_client.dart';
import '../domain/announcement.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 公告 API。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【API 层职责】
/// - 封装 HTTP 请求细节
/// - 只关心接口路径和参数
/// - 解析响应为 Entity（使用 fromJson）
///
class AnnouncementApi {
  const AnnouncementApi(this._client);

  final ApiClient _client;

  /// 获取公告列表。
  ///
  /// 【自动转换】
  /// 通过 `fromJson` 参数，ApiClient 自动将 JSON 转换为 Announcement。
  Future<List<Announcement>> fetchList() async {
    // 获取原始列表数据
    final list = await _client.get<List<dynamic>>('/announcement/list');

    // 列表元素需要手动遍历转换（因为 API 返回的是 List<dynamic>）
    return list
        .cast<Map<String, dynamic>>()
        .map(Announcement.fromJson)
        .toList();
  }
}
