import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/extensions/context_ext.dart';
import '../../../shared/ui/widgets/common_app_bar.dart';
import '../../customer/routing/customer_routes.dart';
import '../../riverpod_demo/routing/riverpod_demo_routes.dart';
import '../routing/demo_routes.dart';

class DemoHubPage extends StatelessWidget {
  const DemoHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: CommonAppBar(title: l10n.demoHubTitle),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DemoTile(
            icon: Icons.people_outline,
            title: l10n.demoCustomerTitle,
            subtitle: l10n.demoCustomerSubtitle,
            onTap: () => context.push(CustomerRoutes.customersPath),
          ),
          _DemoTile(
            icon: Icons.auto_stories_outlined,
            title: 'Riverpod 学习',
            subtitle: '状态管理框架学习 Demo（6课）',
            onTap: () => context.push(RiverpodDemoRoutes.riverpodDemoPath),
          ),
          _DemoTile(
            icon: Icons.cloud_upload_outlined,
            title: l10n.demoBusinessLogTitle,
            subtitle: l10n.demoBusinessLogSubtitle,
            onTap: () => context.push(DemoRoutes.businessLogDemoPath),
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
