import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../shared/extensions/context_ext.dart';

class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final index = path == RoutePaths.settings ? 1 : 0;
    final l10n = context.l10n;
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) =>
            context.go(i == 0 ? RoutePaths.demos : RoutePaths.settings),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.widgets_outlined),
            selectedIcon: const Icon(Icons.widgets),
            label: l10n.navDemos,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
