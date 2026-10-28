import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app/theme/app_colors.dart';
import 'core/widgets/app_bottom_navigation.dart';

class MainShell extends StatelessWidget {
  static const Set<String> _rootTabRoutes = {
    '/main/home',
    '/main/donation',
    '/main/pandits',
    '/main/store',
    '/main/profile',
    '/main/pooja',
  };

  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  static bool shouldShowBottomBar(String? matchedLocation) {
    if (matchedLocation == null || matchedLocation.isEmpty) return false;
    final normalizedLocation = matchedLocation.split('?').first;
    return _rootTabRoutes.contains(normalizedLocation);
  }

  void _onTabSelected(int index) {navigationShell.goBranch(index,initialLocation: index == navigationShell.currentIndex);}

  @override
  Widget build(BuildContext context) {
    final matchedLocation = GoRouter.of(context).state.matchedLocation;
    final shouldShowBar = shouldShowBottomBar(matchedLocation);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: shouldShowBar
          ? AppBottomNavigation(currentIndex: navigationShell.currentIndex,onTap: _onTabSelected)
          : null,
    );
  }
}
