import 'package:flutter/material.dart';
import 'package:flutter_enterprise_starter/features/customer/routing/customer_routes.dart';

import '../../../shared/extensions/context_ext.dart';
import '../../../shared/routing/app_route_stack.dart';
import '../../../shared/ui/widgets/app_button.dart';
import '../../../shared/ui/widgets/common_app_bar.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.title, required this.message});
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CommonAppBar(title: context.l10n.resultTitle, showBackButton: false,),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 76, color: Colors.green),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 28),
          AppButton(
            label: context.l10n.resultBackCustomers,
            icon: Icons.home_outlined,
            onPressed: () => context.popUntilRouteNameOrGo(
              routeName: CustomerRoutes.customersName,
              fallbackLocation: CustomerRoutes.customersPath,
            ),
          ),
        ],
      ),
    ),
  );
}
