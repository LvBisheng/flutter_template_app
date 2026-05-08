import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/local_storage.dart';

const _localeOptionStorageKey = 'app.locale.option';

enum AppLocaleOption {
  system('system', null),
  zhHans('zh', Locale('zh')),
  en('en', Locale('en'));

  const AppLocaleOption(this.storageValue, this.locale);

  final String storageValue;
  final Locale? locale;

  static AppLocaleOption fromStorage(String? value) {
    for (final option in values) {
      if (option.storageValue == value) return option;
    }
    return AppLocaleOption.system;
  }
}

class AppLocaleState {
  const AppLocaleState({required this.option});

  final AppLocaleOption option;
  Locale? get locale => option.locale;
}

final appLocaleControllerProvider =
    NotifierProvider<AppLocaleController, AppLocaleState>(
      AppLocaleController.new,
    );

class AppLocaleController extends Notifier<AppLocaleState> {
  @override
  AppLocaleState build() {
    final option = AppLocaleOption.fromStorage(
      LocalStorage.getString(_localeOptionStorageKey),
    );
    return AppLocaleState(option: option);
  }

  Future<void> select(AppLocaleOption option) async {
    state = AppLocaleState(option: option);
    await LocalStorage.setString(_localeOptionStorageKey, option.storageValue);
  }
}
