import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/store_home/store_home_bloc.dart';
import '../bloc/store_home/store_home_event.dart';
import '../bloc/store_home/store_home_state.dart';
import '../widgets/store_banner.dart';
import '../widgets/store_category_list.dart';
import '../widgets/store_header.dart';
import '../widgets/store_product_section.dart';

class StoreHomePage extends StatelessWidget {
  const StoreHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<StoreHomeBloc>()..add(const LoadStoreHome())),
        BlocProvider<CartBloc>(create: (_) => getIt<CartBloc>()),
      ],
      child: const StoreHomeView(),
    );
  }
}

class StoreHomeView extends StatelessWidget {
  const StoreHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<StoreHomeBloc, StoreHomeState>(
          builder: (context, state) {
            if (state.status == StoreHomeStatus.initial || state.status == StoreHomeStatus.loading) return const _StoreLoadingView();
            if (state.status == StoreHomeStatus.failure) return _StoreErrorView(message: state.errorMessage ?? 'Something went wrong');
            final storeHome = state.storeHome;
            if (storeHome == null) return const _StoreErrorView(message: 'Store data not available');

            return RefreshIndicator(
              onRefresh: () async {
                context.read<StoreHomeBloc>().add(const RefreshStoreHome());
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: StoreHeader()),

                  SliverToBoxAdapter(
                    child: StoreCategoryList(categories: storeHome.categories),
                  ),
                  SliverToBoxAdapter(
                    child: StoreProductSection(
                      title: 'Best Selling Products',
                      products: storeHome.bestSellingProducts,
                    ),
                  ),

                  if (storeHome.banners.isNotEmpty)
                    SliverToBoxAdapter(
                      child: StoreBanner(banner: storeHome.banners.first),
                    ),
                  SliverToBoxAdapter(
                    child: StoreProductSection(
                      title: 'Shop by Occasion',
                      products: storeHome.shopByOccasion,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: StoreProductSection(
                      title: 'Newly Launched',
                      products: storeHome.newlyLaunched,
                    ),
                  ),
                  if (storeHome.banners.length > 1)
                    SliverToBoxAdapter(
                      child: StoreBanner(banner: storeHome.banners[1]),
                    ),
                  SliverToBoxAdapter(
                    child: StoreProductSection(
                      title: 'Best Sellers',
                      products: storeHome.bestSellers,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: StoreProductSection(
                      title: 'Murti and Mala',
                      products: storeHome.murtiAndMala,
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 90)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StoreLoadingView extends StatelessWidget {
  const _StoreLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _StoreErrorView extends StatelessWidget {
  final String message;

  const _StoreErrorView({required this.message});

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
                context.read<StoreHomeBloc>().add(const LoadStoreHome());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
