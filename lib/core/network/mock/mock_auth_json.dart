class MockAuthJson {
  MockAuthJson._();

  static const loginSuccess = r'''
{"code":"0000","message":"success","data":{"token":"mock-token-for-demo-only","user_id":"u_mock","user_name":"Demo Operator"}}
''';

  static const profileSuccess = r'''
{"code":"0000","message":"success","data":{"user_id":"u_mock","user_name":"Demo Operator"}}
''';
}
