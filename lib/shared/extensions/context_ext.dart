import 'package:flutter/material.dart';

import '../../app/l10n/generated/app_localizations.dart';

extension ContextExt on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  AppLocalizations get l10n => AppLocalizations.of(this);
}
