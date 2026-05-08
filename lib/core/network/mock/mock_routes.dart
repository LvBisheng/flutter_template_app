import 'mock_rule.dart';

class MockRoutes {
  MockRoutes._();

  static final routes = {
    for (final rule in MockRuleRegistry.rules) rule.routeKey: rule,
  };
}
