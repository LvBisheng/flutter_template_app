/// 公告 Mock 数据。
///
/// 【脱敏说明】
/// Mock 数据必须脱敏，禁止使用真实数据。
///
class MockAnnouncementJson {
  MockAnnouncementJson._();

  /// 公告列表 Mock 数据。
  ///
  /// 【格式说明】
  /// 必须符合 BaseResponse 格式：
  /// {
  ///   "code": "0",
  ///   "message": "success",
  ///   "data": [ ... ]
  /// }
  static const list = '''
{
  "code": "0000",
  "message": "success",
  "data": [
    {
      "id": "1",
      "title": "系统维护通知",
      "content": "尊敬的用户，我们将于本周六凌晨 2:00-4:00 进行系统维护，届时服务将暂停，请您提前做好准备。给您带来的不便，敬请谅解。",
      "published_at": "2024-01-15T10:00:00Z",
      "is_read": false
    },
    {
      "id": "2",
      "title": "新版 APP 上线公告",
      "content": "我们很高兴地通知您，新版 APP 已正式上线！新版本优化了用户体验，修复了若干已知问题。欢迎您更新体验。",
      "published_at": "2024-01-14T15:30:00Z",
      "is_read": true
    },
    {
      "id": "3",
      "title": "春节放假通知",
      "content": "根据国家规定，春节假期为 2024 年 2 月 10 日至 2 月 17 日，共 8 天。假期期间客服服务将暂停，如有紧急问题请发送邮件至 support@example.com。",
      "published_at": "2024-01-10T09:00:00Z",
      "is_read": true
    }
  ]
}
''';
}
