import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../shared/extensions/context_ext.dart';

class DemoHubPage extends StatelessWidget {
  const DemoHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.demoHubTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DemoTile(
            icon: Icons.people_outline,
            title: l10n.demoCustomerTitle,
            subtitle: l10n.demoCustomerSubtitle,
            onTap: () => context.push(RoutePaths.customers),
          ),
          _DemoTile(
            icon: Icons.cloud_upload_outlined,
            title: l10n.demoBusinessLogTitle,
            subtitle: l10n.demoBusinessLogSubtitle,
            onTap: () => context.push(RoutePaths.businessLogDemo),
          ),
        ],
      ),
    );
  }
}

class _DemoTile extends StatelessWidget {
  const _DemoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}
