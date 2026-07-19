/// ─────────────────────────────────────────────────────────────────────
/// 公告实体。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【Entity vs DTO】
/// - Entity：业务领域对象，与 UI/数据源无关
/// - DTO：数据传输对象，与后端字段名对应
///
/// 这里是 Entity，字段名按照业务语义命名，不依赖后端。
///
class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.publishedAt,
    this.isRead = false,
  });

  /// 公告 ID。
  final String id;

  /// 公告标题。
  final String title;

  /// 公告内容。
  final String content;

  /// 发布时间。
  final DateTime publishedAt;

  /// 是否已读。
  final bool isRead;

  /// 从 JSON 创建实体。
  ///
  /// 【注意】
  /// JSON 字段名与 Entity 字段名可能不同：
  /// - JSON: published_at → Entity: publishedAt
  /// - JSON: is_read → Entity: isRead
  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      publishedAt: DateTime.parse(json['published_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
    );
  }

  /// 复制并更新状态。
  Announcement copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? publishedAt,
    bool? isRead,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      publishedAt: publishedAt ?? this.publishedAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
