import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'runtime_error_controller.dart';

void installGlobalErrorHandlers(ProviderContainer container) {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    container
        .read(runtimeErrorControllerProvider.notifier)
        .captureFlutter(details);
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    container
        .read(runtimeErrorControllerProvider.notifier)
        .capturePlatform(error, stackTrace);
    return true;
  };
}
