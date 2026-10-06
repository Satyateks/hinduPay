import 'package:flutter/material.dart';
import '../bloc/home_state.dart';
import '../modules/pooja/pooja_home_view.dart';
import '../modules/pandit/pandit_home_view.dart';
import '../modules/darshan/darshan_home_view.dart';
import '../modules/donation/donation_home_view.dart';
import '../modules/shop/shop_home_view.dart';

class HomeModuleView extends StatelessWidget {
  final HomeModule module;

  const HomeModuleView({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    switch (module) {
      case HomeModule.pooja:
        return const PoojaHomeView();
      case HomeModule.pandit:
        return const PanditHomeView();
      case HomeModule.darshan:
        return const DarshanHomeView();
      case HomeModule.donation:
        return const DonationHomeView();
      case HomeModule.shop:
        return const ShopHomeView();
    }
  }
}
