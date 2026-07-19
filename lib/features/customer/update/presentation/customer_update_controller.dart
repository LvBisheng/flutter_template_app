import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/api_client.dart';
import '../../detail/domain/customer_profile.dart';
import '../data/customer_update_api.dart';
import '../data/customer_update_repository_impl.dart';
import '../domain/customer_update_field_error.dart';
import '../domain/customer_update_policy.dart';
import '../domain/customer_update_use_case.dart';
import 'customer_update_state.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 客户资料修改控制器。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【StateNotifierProvider.family.autoDispose 说明】
/// - StateNotifierProvider：用于复杂状态管理
/// - family：支持参数传入（客户 ID）
/// - autoDispose：离开页面自动销毁
///
/// 【为什么还用 StateNotifierProvider？】
/// Riverpod 3.x 的 NotifierProvider.family 对带参数的场景支持不够完善，
/// 所以带参数的 Provider 暂时保留使用 StateNotifierProvider.family。
///
/// 【family 参数传递】
/// ```dart
/// // Provider 定义
/// StateNotifierProvider.family<Controller, State, String>(...)
///
/// // 使用时传入客户 ID
/// ref.watch(customerUpdateControllerProvider('123'))
///
/// // lambda 的 id 参数就是 '123'
/// ```
///
/// 【autoDispose 的作用】
/// - 进入页面：Provider 创建
/// - 离开页面：Provider 销毁，释放内存
/// - 再次进入：Provider 重新创建
///
/// 【典型用法】
/// ```dart
/// // 监听状态
/// final state = ref.watch(customerUpdateControllerProvider(customerId));
///
/// // 调用方法
/// ref.read(customerUpdateControllerProvider(customerId).notifier).load();
/// ```
///
final customerUpdateControllerProvider =
    StateNotifierProvider.family.autoDispose<
        CustomerUpdateController, CustomerUpdateState, String>(
      // 级联操作符 ..：创建 Controller 后立即调用 load()，然后返回 Controller 对象
      // 等价于：
      // final controller = CustomerUpdateController(ref, id);
      // controller.load();
      // return controller;
      (ref, id) => CustomerUpdateController(ref, id)..load(),
    );

/// 客户资料修改控制器。
///
/// 负责管理表单状态、字段校验、数据加载和提交。
class CustomerUpdateController extends StateNotifier<CustomerUpdateState> {
  CustomerUpdateController(this._ref, this._customerId)
      : super(const CustomerUpdateState());

  final Ref _ref;
  final String _customerId;

  late final _repository = CustomerUpdateRepositoryImpl(
    CustomerUpdateApi(_ref.read(apiClientProvider)),
  );
  
  /// 加载客户资料。
  Future<void> load() async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      final profile = await _repository.fetchProfile(_customerId);
      appLogger.i('Customer update profile loaded: $_customerId');
      state = state.copyWith(
        loading: false,
        profile: profile,
        name: profile.name,
        email: profile.email,
        mobile: profile.mobile,
        industryCode: profile.industryCode,
        professionCode: profile.professionCode,
        birthday: profile.birthday,
      );
    } catch (e) {
      appLogger.e('Customer update profile load failed', error: e);
      state = state.copyWith(loading: false, errorMessage: e.toString());
    }
  }

  /// 更新姓名。
  void nameChanged(String v) => _updateAndValidate(state.copyWith(name: v));

  /// 更新邮箱。
  void emailChanged(String v) => _updateAndValidate(state.copyWith(email: v));

  /// 更新手机号。
  void mobileChanged(String v) =>
      _updateAndValidate(state.copyWith(mobile: v));

  /// 更新行业。
  ///
  /// 行业变化后必须清空职业，因为旧职业可能不属于新行业。
  void industryChanged(String code) {
    _updateAndValidate(
      state.copyWith(industryCode: code, clearProfession: true),
    );
  }

  /// 更新职业。
  void professionChanged(String code) =>
      _updateAndValidate(state.copyWith(professionCode: code));

  /// 更新是否接受条款。
  void acceptedChanged(bool v) =>
      _updateAndValidate(state.copyWith(acceptedTerms: v));

  /// 更新联系方式。
  void contactMethodChanged(String v) =>
      state = state.copyWith(contactMethod: v);

  /// 更新生日。
  void birthdayChanged(DateTime v) =>
      state = state.copyWith(birthday: v);

  /// 更新状态并校验。
  ///
  /// 已提交过的表单才做实时校验，避免用户输入时就报错。
  void _updateAndValidate(CustomerUpdateState next) {
    state = next.submittedOnce
        ? next.copyWith(fieldErrors: CustomerUpdatePolicy.validateField(next))
        : next;
  }

  /// 提交表单。
  ///
  /// 返回 null 表示成功，否则返回第一个字段错误。
  Future<CustomerUpdateFieldError?> submit() async {
    final fieldErrors = CustomerUpdatePolicy.validateField(state);
    state = state.copyWith(fieldErrors: fieldErrors, submittedOnce: true);
    if (fieldErrors.isNotEmpty) {
      return fieldErrors.values.first;
    }

    final base = state.profile!;
    final industry = CustomerUpdatePolicy.industries.firstWhere(
      (e) => e.value == state.industryCode,
    );
    final profession = CustomerUpdatePolicy.professions(
      state.industryCode!,
    ).firstWhere((e) => e.value == state.professionCode);

    final updated = CustomerProfile(
      id: base.id,
      name: state.name,
      email: state.email,
      mobile: state.mobile,
      status: base.status,
      industryCode: industry.value,
      industryName: industry.label,
      professionCode: profession.value,
      professionName: profession.label,
      birthday: state.birthday,
      lastUpdatedAt: base.lastUpdatedAt,
    );

    state = state.copyWith(submitting: true);
    try {
      appLogger.i('Customer update submit started: ${base.id}');
      await CustomerUpdateUseCase(_repository).submit(updated);
      appLogger.i('Customer update submit succeeded: ${base.id}');
      return null;
    } catch (e) {
      appLogger.e('Customer update submit failed', error: e);
      rethrow;
    } finally {
      state = state.copyWith(submitting: false);
    }
  }
}
