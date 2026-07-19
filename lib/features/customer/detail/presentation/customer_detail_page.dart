import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/extensions/datetime_ext.dart';
import '../../../../shared/extensions/context_ext.dart';
import '../../../../shared/ui/feedback/app_loading.dart';
import '../../../../shared/ui/screen/screen.dart';
import '../../../../shared/ui/widgets/app_button.dart';
import '../../../../shared/ui/widgets/app_error_view.dart';
import '../../../../shared/ui/widgets/common_app_bar.dart';
import '../../../../shared/utils/string_utils.dart';
import '../../routing/customer_routes.dart';
import 'customer_detail_controller.dart';

class CustomerDetailPage extends ConsumerWidget {
  const CustomerDetailPage({super.key, required this.customerId});
  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(customerDetailControllerProvider(customerId));
    final l10n = context.l10n;
    return Scaffold(
      appBar: CommonAppBar(title: l10n.customerDetailTitle(customerId)),
      body: detail.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorView(
          message: e.toString(),
          onRetry: () =>
              ref.invalidate(customerDetailControllerProvider(customerId)),
        ),
        data: (c) => ListView(
          padding: EdgeInsets.all(16.s),
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 12.s),
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
            SizedBox(height: 16.s),
            AppButton(
              label: l10n.customerEditProfile,
              icon: Icons.edit_outlined,
              onPressed: () =>
                  context.push(CustomerRoutes.customerUpdatePath(customerId)),
            ),
            SizedBox(height: 12.s),
            AppButton(
              label: l10n.customerUpdateIdentity,
              icon: Icons.badge_outlined,
              onPressed: () =>
                  context.push(CustomerRoutes.identityUpdatePath(customerId)),
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
    padding: EdgeInsets.symmetric(vertical: 6.s),
    child: Row(
      children: [
        SizedBox(width: 96.s, child: Text(label)),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
