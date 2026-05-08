enum AppEnv { sit, sit2, sit3, uat, uat1, uat2, prd }

extension AppEnvX on AppEnv {
  String get label => name;

  static AppEnv parse(String value) {
    return AppEnv.values.firstWhere(
      (env) => env.name == value,
      orElse: () => AppEnv.sit,
    );
  }
}
