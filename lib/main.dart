import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'bootstrap.dart';

void main() {
  bootstrap(
    (container) => runApp(
      UncontrolledProviderScope(container: container, child: const AppRoot()),
    ),
  );
}
