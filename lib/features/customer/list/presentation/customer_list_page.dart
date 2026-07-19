import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/extensions/datetime_ext.dart';
import '../../../../shared/extensions/context_ext.dart';
import '../../../../shared/ui/feedback/app_loading.dart';
import '../../../../shared/ui/screen/screen.dart';
import '../../../../shared/ui/widgets/app_empty_view.dart';
import '../../../../shared/ui/widgets/app_error_view.dart';
import '../../../../shared/ui/widgets/common_app_bar.dart';
import '../../../../shared/utils/string_utils.dart';
import '../../routing/customer_routes.dart';
import 'customer_list_controller.dart';

/// 客户列表页面。
///
/// 【架构说明】
/// - 使用 ConsumerWidget 监听 Provider
/// - Provider 带 autoDispose，进入页面自动加载，离开页面自动销毁
/// - 通过 AsyncNotifier 实现加载/错误/数据三种状态
/// - 支持下拉刷新
///
class CustomerListPage extends ConsumerWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customerListControllerProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: CommonAppBar(title: l10n.customerListTitle),
      body: customers.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorView(
          message: e.toString(),
          onRetry: () =>
              ref.read(customerListControllerProvider.notifier).refresh(),
        ),
        data: (items) {
          if (items.isEmpty) {
            return AppEmptyView(message: l10n.customerListEmpty);
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(customerListControllerProvider.notifier).refresh(),
            child: ListView.separated(
              padding: EdgeInsets.all(16.s),
              itemCount: items.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.s),
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
                    onTap: () => context.push(CustomerRoutes.customerDetailPath(c.id)),
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
