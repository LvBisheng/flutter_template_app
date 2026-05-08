import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../shared/extensions/datetime_ext.dart';
import '../../../shared/extensions/context_ext.dart';
import '../../../shared/ui/feedback/app_loading.dart';
import '../../../shared/ui/widgets/app_button.dart';
import '../../../shared/ui/widgets/app_error_view.dart';
import '../../../shared/utils/string_utils.dart';
import 'customer_detail_controller.dart';

class CustomerDetailPage extends ConsumerWidget {
  const CustomerDetailPage({super.key, required this.customerId});
  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(customerDetailControllerProvider(customerId));
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerDetailTitle(customerId))),
      body: detail.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorView(
          message: e.toString(),
          onRetry: () =>
              ref.invalidate(customerDetailControllerProvider(customerId)),
        ),
        data: (c) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    _Info(l10n.customerEmail, c.email),
                    _Info(
                      l10n.customerMobile,
                      StringUtils.maskMobile(c.mobile),
                    ),
                    _Info(l10n.customerVerificationStatus, c.status),
                    _Info(
                      l10n.customerIndustryProfession,
                      '${c.industryName ?? '-'} / ${c.professionName ?? '-'}',
                    ),
                    _Info(l10n.customerLastUpdated, c.lastUpdatedAt.ymdHm),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: l10n.customerEditProfile,
              icon: Icons.edit_outlined,
              onPressed: () =>
                  context.push(RoutePaths.customerUpdate(customerId)),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: l10n.customerUpdateIdentity,
              icon: Icons.badge_outlined,
              onPressed: () =>
                  context.push(RoutePaths.identityUpdate(customerId)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        SizedBox(width: 96, child: Text(label)),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
