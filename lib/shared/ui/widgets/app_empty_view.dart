import 'package:flutter/material.dart';

import '../../extensions/context_ext.dart';

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Text(message ?? context.l10n.commonNoData),
    ),
  );
}
