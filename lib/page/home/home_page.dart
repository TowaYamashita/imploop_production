import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imploop/page/task_list/task_list_page.dart';
import 'package:imploop/page/timer/timer_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

final displayPageSelectorProvider = StateProvider<PersistentTabController>(
    (_) => PersistentTabController(initialIndex: 0));

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  List<Widget> _buildScreens() {
    return [
      const TimerPage(),
      const TaskListPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(context) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.timer),
        title: 'タイマー',
        activeColorPrimary: Theme.of(context).colorScheme.primaryVariant,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add_task),
        title: 'Task一覧',
        activeColorPrimary: Theme.of(context).colorScheme.primaryVariant,
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PersistentTabController _controller =
        ref.read(displayPageSelectorProvider.notifier).state;

    return WillPopScope(
      onWillPop: () async => false,
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(context),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style3, // Choose the nav bar style with this property.
      ),
    );
  }
}
