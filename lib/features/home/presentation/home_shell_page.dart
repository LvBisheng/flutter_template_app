import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_exit_handler.dart';
import '../../../shared/extensions/context_ext.dart';
import '../../../shared/routing/refresh_on_visible.dart';
import '../routing/home_routes.dart';

/// ─────────────────────────────────────────────────────────────────────
/// 首页 Shell 容器（底部导航栏）。
/// ─────────────────────────────────────────────────────────────────────
///
/// 【职责】
/// 1. 提供底部导航栏（Tab 切换）
/// 2. 拦截返回键，弹出退出确认对话框
/// 3. 监听 Tab 变化，通知目标页面重新可见
///
/// 【Tab 结构】
/// - 公告列表（首页）：/home/announcements
/// - Demo Hub：/home/demos
/// - 我的：/home/me
///
/// 【退出确认】
/// 首页是"根页面"，用户无法再返回，所以需要弹出确认框。
/// 使用 wrapWithExitConfirmation() 统一处理。
///
class HomeShellPage extends ConsumerStatefulWidget {
  const HomeShellPage({super.key, required this.navigationShell});

  /// StatefulShellRoute 提供的 tab 导航容器。
  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends ConsumerState<HomeShellPage> {
  late int _lastIndex;

  @override
  void initState() {
    super.initState();
    _lastIndex = widget.navigationShell.currentIndex;
  }

  @override
  void didUpdateWidget(covariant HomeShellPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    final index = widget.navigationShell.currentIndex;

    // Tab 切换时，通知对应页面刷新
    if (_lastIndex != index) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _notifyTabVisible(_pathForIndex(index));
      });
    }
    _lastIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return wrapWithExitConfirmation(
      context: context,
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: widget.navigationShell.goBranch,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.campaign_outlined),
              selectedIcon: const Icon(Icons.campaign),
              label: l10n.navAnnouncements,
            ),
            NavigationDestination(
              icon: const Icon(Icons.widgets_outlined),
              selectedIcon: const Icon(Icons.widgets),
              label: l10n.navDemos,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: l10n.navMe,
            ),
          ],
        ),
      ),
    );
  }

  /// Tab 切换时通知目标页面重新可见。
  void _notifyTabVisible(String path) {
    ref
        .read(visibleRefreshProvider.notifier)
        .notify(path, reason: VisibleRefreshReason.tabVisible);
  }

  String _pathForIndex(int index) {
    return switch (index) {
      0 => HomeRoutes.announcementsPath,
      1 => HomeRoutes.demosPath,
      2 => HomeRoutes.mePath,
      _ => HomeRoutes.announcementsPath,
    };
  }
}
