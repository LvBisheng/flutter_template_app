import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../shared/ui/widgets/app_button.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.title, required this.message});
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('处理结果')),
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
            label: '返回客户列表',
            icon: Icons.home_outlined,
            onPressed: () => context.go(RoutePaths.customers),
          ),
        ],
      ),
    ),
  );
}
