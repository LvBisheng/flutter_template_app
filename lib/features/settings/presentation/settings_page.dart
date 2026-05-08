import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/env/env_config.dart';
import '../../../app/l10n/app_locale_controller.dart';
import '../../../capabilities/auth/session_manager.dart';
import '../../../shared/extensions/context_ext.dart';
import '../../../shared/ui/feedback/app_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(sessionManagerProvider);
    final env = ref.watch(envConfigProvider);
    final locale = ref.watch(appLocaleControllerProvider);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle(l10n.settingsAccount),
          _Tile(
            l10n.settingsLoginStatus,
            auth.isLoggedIn
                ? l10n.settingsLoggedInUser(auth.userName ?? '-')
                : l10n.settingsNotLoggedIn,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(sessionManagerProvider.notifier).clearToken();
            },
            icon: const Icon(Icons.delete_outline),
            label: Text(l10n.settingsClearToken),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () async {
              final ok = await AppDialog.confirm(
                context,
                l10n.settingsLogoutConfirm,
              );
              if (ok) await ref.read(sessionManagerProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
            label: Text(l10n.settingsLogout),
          ),
          const SizedBox(height: 24),
          _SectionTitle(l10n.settingsLanguage),
          RadioGroup<AppLocaleOption>(
            groupValue: locale.option,
            onChanged: (option) {
              if (option != null) {
                ref.read(appLocaleControllerProvider.notifier).select(option);
              }
            },
            child: Column(
              children: [
                _LanguageTile(
                  option: AppLocaleOption.system,
                  title: l10n.settingsLanguageSystem,
                ),
                _LanguageTile(
                  option: AppLocaleOption.zhHans,
                  title: l10n.settingsLanguageChinese,
                ),
                _LanguageTile(
                  option: AppLocaleOption.en,
                  title: l10n.settingsLanguageEnglish,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionTitle(l10n.settingsAppInfo),
          _Tile(l10n.settingsCurrentEnv, env.env.name),
          _Tile(l10n.settingsBaseUrl, env.baseUrl),
          _Tile(
            l10n.settingsDiagnosticsTool,
            env.switchEnabled
                ? l10n.settingsFloatingButton
                : l10n.settingsProductionDisabled,
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.option, required this.title});

  final AppLocaleOption option;
  final String title;

  @override
  Widget build(BuildContext context) => RadioListTile<AppLocaleOption>(
    contentPadding: EdgeInsets.zero,
    title: Text(title),
    value: option,
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _Tile extends StatelessWidget {
  const _Tile(this.title, this.value);
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(title: Text(title), subtitle: Text(value)),
  );
}
