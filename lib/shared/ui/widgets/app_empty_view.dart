import 'package:flutter/material.dart';

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({super.key, this.message = '暂无数据'});
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(padding: const EdgeInsets.all(32), child: Text(message)),
  );
}
