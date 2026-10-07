import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app/theme/app_colors.dart';
import 'core/widgets/app_bottom_navigation.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});
  void _onTabSelected(int index) {navigationShell.goBranch(index,initialLocation: index == navigationShell.currentIndex);}

  @override
  Widget build(BuildContext context) {
    return Scaffold(  backgroundColor: AppColors.background,  extendBody: true,

      body: navigationShell,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}
