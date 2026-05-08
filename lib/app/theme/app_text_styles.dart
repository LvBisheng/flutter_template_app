import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const section = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontSize: 14,
    height: 1.35,
    color: AppColors.textPrimary,
  );
  static const muted = TextStyle(fontSize: 13, color: AppColors.textSecondary);
}
