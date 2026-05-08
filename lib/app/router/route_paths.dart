class RoutePaths {
  RoutePaths._();

  static const login = '/login';
  static const home = '/home';
  static const customers = '/home/customers';
  static const settings = '/home/settings';
  static String customer(String id) => '/customer/$id';
  static String customerUpdate(String id) => '/customer/$id/update';
  static String identityUpdate(String id) => '/customer/$id/identity-update';
  static const result = '/result';
}
