import '../../customer_detail/domain/customer_profile.dart';
import '../presentation/customer_update_state.dart';
import 'customer_update_policy.dart';
import 'customer_update_repository.dart';

/// 提交客户资料的一次完整业务动作。
///
/// UseCase 不弹 toast，也不跳页面，只负责编排“校验 -> 组装实体 -> 提交”。
class CustomerUpdateUseCase {
  const CustomerUpdateUseCase(this._repository);
  final CustomerUpdateRepository _repository;

  Future<void> submit(CustomerProfile profile) =>
      _repository.updateProfile(profile);

  String? validate(CustomerUpdateState state) =>
      CustomerUpdatePolicy.validate(state);
}
