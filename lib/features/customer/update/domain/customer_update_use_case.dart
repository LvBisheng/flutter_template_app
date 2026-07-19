import '../../detail/domain/customer_profile.dart';
import '../presentation/customer_update_state.dart';
import 'customer_update_field_error.dart';
import 'customer_update_policy.dart';
import 'customer_update_repository.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 客户资料修改业务用例（UseCase）。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 编排"校验 -> 组装实体 -> 提交"的完整业务流程。
///
/// 【UseCase 的作用】
/// - Controller 只负责管理 UI 状态
/// - UseCase 负责封装具体的业务流程
/// - 如果业务逻辑简单，可以直接在 Controller 里调用 Repository
/// - 如果业务逻辑复杂（多步骤、跨 Repository），建议用 UseCase
///
/// 【本 UseCase 的流程】
/// ```
/// Controller 调用 UseCase.submit(profile)
///         ↓
/// Repository.updateProfile(profile)
///         ↓
/// 返回成功/失败
/// ```
///
/// 【为什么 UseCase 不弹 Toast、不跳页面？】
/// UseCase 是纯业务逻辑，不应该关心 UI 层的行为：
/// - Toast、跳页面是 presentation 层的事
/// - 这样 UseCase 可以在不同页面复用
/// - 也方便单元测试
///
class CustomerUpdateUseCase {
  const CustomerUpdateUseCase(this._repository);

  final CustomerUpdateRepository _repository;

  /// 提交客户资料。
  ///
  /// 【流程】
  /// 1. 组装请求参数（由 Controller 完成）
  /// 2. 调用 Repository 提交
  ///
  Future<void> submit(CustomerProfile profile) =>
      _repository.updateProfile(profile);

  /// 校验表单状态。
  ///
  /// 委托给 Policy 执行具体校验。
  CustomerUpdateFieldError? validate(CustomerUpdateState state) =>
      CustomerUpdatePolicy.validate(state);
}
