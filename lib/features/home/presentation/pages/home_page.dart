import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../../../core/di/injection.dart';
import '../widgets/home_header.dart';
import '../widgets/home_promo_banner.dart';
import '../widgets/pandit_section.dart';
import '../widgets/pooja_section.dart';
import '../widgets/quick_action.dart';
import '../widgets/support_section.dart';
import '../widgets/temple_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>()..add(const LoadHome()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading ||state.status == HomeStatus.initial) return const _HomeLoadingView();
            if (state.status == HomeStatus.failure) return _HomeErrorView(message: state.errorMessage ?? 'Something went wrong');
            final home = state.home;
            if (home == null) return const _HomeErrorView(message: 'Home data not available');
            

            return RefreshIndicator(
              onRefresh: () async {context.read<HomeBloc>().add(const RefreshHome());},
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: HomeHeader()),
                  SliverToBoxAdapter(child: QuickActions(actions: home.quickActions)),
                  // const SliverToBoxAdapter(child: HomePromoBanner()),
                  SliverToBoxAdapter(child: TempleSection(temples: home.temples)),
                  const SliverToBoxAdapter(child: SupportSection()),
                  const SliverToBoxAdapter(child: SacredBanner()),
                  SliverToBoxAdapter(child: PoojaSection(poojas: home.poojas)),
                  SliverToBoxAdapter(child: PanditSection()),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HomeLoadingView extends StatelessWidget {
  const _HomeLoadingView();

  @override
  Widget build(BuildContext context) {
    // Baad mein aapke existing shimmer widgets
    // yahan exact Home shimmer ke saath replace karenge.
    return const Center(child: CircularProgressIndicator());
  }
}

class _HomeErrorView extends StatelessWidget {
  final String message;

  const _HomeErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<HomeBloc>().add(const LoadHome());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
