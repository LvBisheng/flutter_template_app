import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../core/logging/app_logger.dart';
import '../features/diagnostics/presentation/dev_tool_overlay.dart';
import 'l10n/app_locale_controller.dart';
import 'l10n/generated/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(appLocaleControllerProvider);
    return TalkerWrapper(
      talker: appTalker,
      options: const TalkerWrapperOptions(
        enableExceptionAlerts: true,
        enableErrorAlerts: false,
      ),
      child: MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        locale: locale.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        routerConfig: router,
        builder: (context, child) =>
            DevToolOverlay(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
