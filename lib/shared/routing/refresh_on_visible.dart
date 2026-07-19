import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 页面重新可见后触发刷新的原因。
///
/// 类似 iOS 中 view controller 的可见生命周期，但在 Flutter 里需要区分
/// Tab 切换和 Navigator push/pop 两类来源。
enum VisibleRefreshReason {
  /// 页面首次进入 widget tree 后的首帧刷新。
  firstVisible,

  /// Shell tab 从其他 tab 切回当前 tab。
  tabVisible,

  /// 当前页面 push 出去的页面 pop 后返回。
  popNext,

  /// 业务主动触发的可见刷新。
  manual,
}

/// 一次页面可见刷新事件。
class VisibleRefreshEvent {
  const VisibleRefreshEvent({
    required this.version,
    required this.key,
    required this.reason,
  });

  /// 递增序号，用来保证相同 key 的连续事件也会被监听到。
  final int version;

  /// 刷新目标，一般使用路由 path，例如 `/home/announcements`。
  final String key;

  /// 刷新原因。
  final VisibleRefreshReason reason;
}

final visibleRefreshProvider =
    NotifierProvider<VisibleRefreshNotifier, VisibleRefreshEvent?>(
      VisibleRefreshNotifier.new,
    );

/// 页面可见刷新事件中心。
class VisibleRefreshNotifier extends Notifier<VisibleRefreshEvent?> {
  int _version = 0;

  @override
  VisibleRefreshEvent? build() => null;

  /// 通知指定页面重新可见。
  void notify(
    String key, {
    VisibleRefreshReason reason = VisibleRefreshReason.manual,
  }) {
    state = VisibleRefreshEvent(version: ++_version, key: key, reason: reason);
  }
}

/// 给 ConsumerState 页面复用的“可见时刷新”能力。
///
/// 用法：
/// ```dart
/// class _PageState extends ConsumerState<Page>
///     with RefreshOnVisibleMixin<Page> {
///   @override
///   String get visibleRefreshKey => MyRoutes.pagePath;
///
///   @override
///   Future<void> onVisibleRefresh(VisibleRefreshReason reason) {
///     return ref.read(myControllerProvider.notifier).refresh();
///   }
/// }
/// ```
mixin RefreshOnVisibleMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  /// 当前页面接收刷新事件的 key，推荐使用路由 path。
  String get visibleRefreshKey;

  /// 是否在首次进入 widget tree 后刷新。
  bool get refreshOnFirstVisible => true;

  /// 是否响应 Shell tab 切回事件。
  bool get refreshOnTabVisible => true;

  /// 页面可见时执行的刷新动作。
  @protected
  FutureOr<void> onVisibleRefresh(VisibleRefreshReason reason);

  @override
  void initState() {
    super.initState();

    ref.listenManual<VisibleRefreshEvent?>(visibleRefreshProvider, (_, event) {
      if (event == null) return;
      if (!refreshOnTabVisible) return;
      if (event.reason != VisibleRefreshReason.tabVisible) return;
      if (event.key != visibleRefreshKey) return;

      refreshWhenVisible(reason: event.reason);
    });

    if (refreshOnFirstVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        refreshWhenVisible(reason: VisibleRefreshReason.firstVisible);
      });
    }
  }

  /// 主动触发当前页面的可见刷新。
  @protected
  void refreshWhenVisible({
    VisibleRefreshReason reason = VisibleRefreshReason.manual,
  }) {
    if (!mounted) return;
    Future.sync(() => onVisibleRefresh(reason)).ignore();
  }

  /// push 到新页面，并在该页面 pop 回来后刷新当前页面。
  @protected
  Future<R?> pushAndRefreshOnReturn<R>(String location, {Object? extra}) async {
    final result = await context.push<R>(location, extra: extra);
    refreshWhenVisible(reason: VisibleRefreshReason.popNext);
    return result;
  }
}
