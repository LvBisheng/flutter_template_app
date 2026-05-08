import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../core/logging/app_logger.dart';
import '../../../shared/extensions/context_ext.dart';

class LogConsolePage extends StatelessWidget {
  const LogConsolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TalkerScreen(
      talker: appTalker,
      appBarTitle: context.l10n.devToolLogTitle,
      isLogOrderReversed: true,
    );
  }
}
