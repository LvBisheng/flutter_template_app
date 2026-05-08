import 'dart:convert';

class MockCustomerJson {
  MockCustomerJson._();

  static const listSuccess = r'''
{"code":"0000","message":"success","data":[
{"cust_id":"C10001","cust_name":"Demo Customer A","email_addr":"alpha@example.invalid","mobile_no":"13800000001","status":"verified","last_updated_at":"2026-05-01T10:30:00Z"},
{"cust_id":"C10002","cust_name":"Demo Customer B","email_addr":"bravo@example.invalid","mobile_no":"13800000002","status":"pending","last_updated_at":"2026-05-03T08:15:00Z"},
{"cust_id":"C10003","cust_name":"Demo Customer C","email_addr":"charlie@example.invalid","mobile_no":"13800000003","status":"draft","last_updated_at":"2026-05-06T12:00:00Z"}
]}
''';

  static const detailSuccess = r'''
{"code":"0000","message":"success","data":{"cust_id":"C10001","cust_name":"Demo Customer A","email_addr":"alpha@example.invalid","mobile_no":"13800000001","status":"verified","industry_cd":"tech","industry_name":"Technology","profession_cd":"engineer","profession_name":"Engineer","birthday":"1990-01-01","last_updated_at":"2026-05-01T10:30:00Z"}}
''';

  static String detailSuccessFor(String customerId) {
    final detail = switch (customerId) {
      'C10002' => {
        'cust_id': 'C10002',
        'cust_name': 'Demo Customer B',
        'email_addr': 'bravo@example.invalid',
        'mobile_no': '13800000002',
        'status': 'pending',
        'industry_cd': 'finance',
        'industry_name': 'Finance',
        'profession_cd': 'analyst',
        'profession_name': 'Analyst',
        'birthday': '1988-08-08',
        'last_updated_at': '2026-05-03T08:15:00Z',
      },
      'C10003' => {
        'cust_id': 'C10003',
        'cust_name': 'Demo Customer C',
        'email_addr': 'charlie@example.invalid',
        'mobile_no': '13800000003',
        'status': 'draft',
        'industry_cd': 'service',
        'industry_name': 'Service',
        'profession_cd': 'consultant',
        'profession_name': 'Consultant',
        'birthday': '1995-03-15',
        'last_updated_at': '2026-05-06T12:00:00Z',
      },
      _ => {
        'cust_id': 'C10001',
        'cust_name': 'Demo Customer A',
        'email_addr': 'alpha@example.invalid',
        'mobile_no': '13800000001',
        'status': 'verified',
        'industry_cd': 'tech',
        'industry_name': 'Technology',
        'profession_cd': 'engineer',
        'profession_name': 'Engineer',
        'birthday': '1990-01-01',
        'last_updated_at': '2026-05-01T10:30:00Z',
      },
    };
    return jsonEncode({'code': '0000', 'message': 'success', 'data': detail});
  }

  static const updateSuccess = r'''
{"code":"0000","message":"success","data":{"request_id":"REQ-MOCK-CUSTOMER-UPDATE"}}
''';
}
