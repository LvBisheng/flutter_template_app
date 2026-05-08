import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../core/logging/app_logger.dart';
import '../features/diagnostics/presentation/dev_tool_overlay.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return TalkerWrapper(
      talker: appTalker,
      options: const TalkerWrapperOptions(
        enableExceptionAlerts: true,
        enableErrorAlerts: false,
      ),
      child: MaterialApp.router(
        title: 'Flutter Enterprise Starter',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routerConfig: router,
        builder: (context, child) =>
            DevToolOverlay(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
