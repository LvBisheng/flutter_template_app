import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../shared/extensions/datetime_ext.dart';
import '../../../shared/ui/feedback/app_loading.dart';
import '../../../shared/ui/widgets/app_empty_view.dart';
import '../../../shared/ui/widgets/app_error_view.dart';
import '../../../shared/utils/string_utils.dart';
import 'customer_list_controller.dart';

class CustomerListPage extends ConsumerWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customerListControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('客户资料管理')),
      body: customers.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorView(
          message: e.toString(),
          onRetry: () =>
              ref.read(customerListControllerProvider.notifier).refresh(),
        ),
        data: (items) {
          if (items.isEmpty) return const AppEmptyView(message: '暂无客户资料');
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(customerListControllerProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final c = items[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(c.name.characters.first)),
                    title: Text(c.name),
                    subtitle: Text(
                      '${c.email}\n${StringUtils.maskMobile(c.mobile)} · ${c.lastUpdatedAt.ymdHm}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(RoutePaths.customer(c.id)),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
