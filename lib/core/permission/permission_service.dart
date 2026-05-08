class PermissionService {
  Future<bool> requestCamera() async {
    // 模板第一版不引入 permission_handler，真实项目可在这里替换为平台权限实现。
    return true;
  }
}
