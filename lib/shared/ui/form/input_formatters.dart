import 'package:flutter/services.dart';

class AppInputFormatters {
  AppInputFormatters._();

  static final mobile = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(11),
  ];
}
