import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/ui/feedback/app_toast.dart';
import '../../../shared/ui/widgets/app_button.dart';
import '../../../shared/ui/widgets/app_text_field.dart';
import 'login_controller.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                const Icon(Icons.business_center, size: 56),
                const SizedBox(height: 16),
                Text(
                  'Flutter Enterprise Starter',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                AppTextField(
                  label: '用户名',
                  initialValue: state.username,
                  onChanged: ref
                      .read(loginControllerProvider.notifier)
                      .usernameChanged,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: '密码',
                  initialValue: state.password,
                  obscureText: true,
                  onChanged: ref
                      .read(loginControllerProvider.notifier)
                      .passwordChanged,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: '登录',
                  loading: state.loading,
                  onPressed: () async {
                    try {
                      await ref.read(loginControllerProvider.notifier).login();
                    } catch (e) {
                      if (context.mounted) AppToast.show(context, e.toString());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
