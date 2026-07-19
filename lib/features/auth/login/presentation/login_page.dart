import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_exit_handler.dart';
import '../../../../shared/extensions/context_ext.dart';
import '../../../../shared/ui/feedback/app_toast.dart';
import '../../../../shared/ui/screen/screen.dart';
import '../../../../shared/ui/widgets/app_button.dart';
import '../../../../shared/ui/widgets/app_text_field.dart';
import 'login_controller.dart';

/// ─────────────────────────────────────────────────────────────────────
/// LoginPage - 登录页面（纯 UI）。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 渲染 UI、处理用户交互、展示结果。
///
/// 【Page 的边界】
/// - 只管 UI：布局、样式、动画
/// - 只管交互：接收用户输入、调用 Controller 方法
/// - 只管展示：成功/失败如何显示（toast、跳转等）
///
/// 【Page 不该做的事】
/// ❌ 业务逻辑（如校验用户名）→ 放 UseCase
/// ❌ 数据获取（如调 API）→ 放 Repository
/// ❌ 状态管理（如存 username）→ 放 Controller
///
/// 【为什么用 ConsumerWidget？】
/// ConsumerWidget 是 Riverpod 提供的 Widget，
/// 可以通过 ref.watch() 监听 Provider 状态变化。
///
/// 当 Controller 的状态变化时：
/// - ref.watch(loginControllerProvider) 会触发 Widget 重建
/// - UI 自动更新（如按钮 loading 状态）
///
/// 【退出确认】
/// 登录页是"根页面"（未登录时的入口），用户侧滑返回应弹出确认框。
/// 使用 wrapWithExitConfirmation() 统一处理。
///
/// ─────────────────────────────────────────────────────────────────────
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听 Controller 状态（状态变化时自动重建 Widget）
    final state = ref.watch(loginControllerProvider);

    // 国际化文案
    final l10n = context.l10n;
    
    // 使用 wrapWithExitConfirmation 包装，添加退出确认功能
    return wrapWithExitConfirmation(
      context: context,
      child: Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            // 限制最大宽度，避免在大屏上输入框过宽
            constraints: BoxConstraints(maxWidth: 420.s),
            child: ListView(
              shrinkWrap: true,
              padding: 24.s.paddingAll,
              children: [
                // Logo
                Icon(Icons.business_center, size: 56.s),
                SizedBox(height: 16.s),

                // 标题
                Text(
                  l10n.loginTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 24.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 28.s),

                // 用户名输入框
                // initialValue 绑定状态值
                // errorText 显示校验错误
                // inputFormatters 限制输入：最多 20 字符，只允许英文/数字/下划线
                AppTextField(
                  label: l10n.loginUsername,
                  initialValue: state.username,
                  errorText: state.usernameError.isEmpty ? null : state.usernameError,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20),
                  ],
                  onChanged: (value) =>
                      ref.read(loginControllerProvider.notifier).usernameChanged(value, l10n),
                ),
                SizedBox(height: 12.s),

                // 密码输入框
                // inputFormatters 限制输入：最多 32 字符
                AppTextField(
                  label: l10n.loginPassword,
                  initialValue: state.password,
                  obscureText: true,
                  maxLength: 32,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(32),
                  ],
                  onChanged:
                      ref.read(loginControllerProvider.notifier).passwordChanged,
                ),
                SizedBox(height: 24.s),

                // 登录按钮
                // loading 状态绑定时按钮会显示 loading 动画
                AppButton(
                  label: l10n.loginSubmit,
                  loading: state.loading,
                  onPressed: state.loginButtonEnable
                      ? () async {
                          try {
                            await ref
                                .read(loginControllerProvider.notifier)
                                .login(l10n: l10n);
                          } catch (e) {
                            // 显示错误 toast
                            // 异常从 UseCase 抛出，Controller 透传，Page 捕获处理
                            if (context.mounted) AppToast.show(context, e.toString());
                          }
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
