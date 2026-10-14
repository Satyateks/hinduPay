import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hindu_pay/features/store/presentation/pages/cart_page.dart';

import '../../core/di/injection.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/donation/presentation/pages/donation_list_page.dart';
import '../../features/donation/presentation/pages/donation_payment_page.dart';
import '../../features/donation/presentation/pages/donation_temple_list.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/pandit/presentation/bloc/pandit_bloc.dart';
import '../../features/pandit/presentation/pages/pandit_page.dart';
import '../../features/pooja/presentation/bloc/pooja_bloc.dart';
import '../../features/pooja/presentation/pages/pooja_list_page.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_event.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

import '../../features/store/presentation/bloc/address/address_bloc.dart';
import '../../features/store/presentation/bloc/address/address_event.dart';
import '../../features/store/presentation/bloc/store_home/store_home_bloc.dart';
import '../../features/store/presentation/bloc/store_home/store_home_event.dart';
import '../../features/store/presentation/pages/product_detail_page.dart';
import '../../features/store/presentation/pages/store_home_page.dart';
import '../../features/store/presentation/widgets/coupon_section.dart';
import '../../features/store/presentation/widgets/price_summary.dart';
import '../../features/store/presentation/widgets/product_address_page.dart';
import '../../main_shall.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',

  routes: [
    // ----------------------------------------------------------
    // SPLASH
    // ----------------------------------------------------------
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) {
        return BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>(),
          child: const SplashPage(),
        );
      },
    ),

    // ----------------------------------------------------------
    // AUTH
    // ----------------------------------------------------------
    GoRoute(
      path: '/auth/login',
      name: 'login',
      builder: (context, state) {
        return BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>(),
          child: const LoginPage(),
        );
      },
    ),

    GoRoute(
      path: '/auth/otp',
      name: 'otp',
      builder: (context, state) {
        final mobile = state.extra as String? ?? '';
        return BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>(),
          child: OtpPage(mobile: mobile),
        );
      },
    ),

    // ----------------------------------------------------------
    // MAIN APPLICATION
    // ----------------------------------------------------------
    StatefulShellRoute.indexedStack(
      builder:
          (
            BuildContext context,
            GoRouterState state,
            StatefulNavigationShell navigationShell,
          ) {
            return MainShell(navigationShell: navigationShell);
          },

      branches: [
        // ------------------------------------------------------
        // HOME
        // ------------------------------------------------------
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/main/home',
              name: 'home',
              builder: (context, state) {
                return BlocProvider<HomeBloc>(
                  create: (_) => getIt<HomeBloc>(),
                  child: const HomePage(),
                );
              },

              routes: [
                // Optional child routes for Home
                GoRoute(
                  path: 'orders',
                  name: 'home-orders',
                  builder: (context, state) {
                    return const _PlaceholderPage(title: 'Orders');
                  },
                ),

                GoRoute(
                  path: 'order/:id',
                  name: 'order-detail',
                  builder: (context, state) {
                    final orderId = state.pathParameters['id'];

                    return _PlaceholderPage(title: 'Order: $orderId');
                  },
                ),

                GoRoute(
                  path: 'temples',
                  name: 'temples',
                  builder: (context, state) {
                    return const _PlaceholderPage(title: 'Temples');
                  },
                ),

                GoRoute(
                  path: 'temple/:id',
                  name: 'temple-detail',
                  builder: (context, state) {
                    final templeId = state.pathParameters['id'];

                    return _PlaceholderPage(title: 'Temple: $templeId');
                  },
                ),

                GoRoute(
                  path: 'darshan',
                  name: 'darshan',
                  builder: (context, state) {
                    return const _PlaceholderPage(title: 'Darshan');
                  },
                ),

                GoRoute(
                  path: 'darshan/booking',
                  name: 'darshan-booking',
                  builder: (context, state) {
                    return const _PlaceholderPage(title: 'Darshan Booking');
                  },
                ),
              ],
            ),
          ],
        ),

        // ------------------------------------------------------
        // DONATION
        // ------------------------------------------------------
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/main/donation',
              name: 'donation',
              builder: (context, state) {
                return const DonateHomeScreen();
              },
              routes: [
                GoRoute(
                  path: '/donation/templeList',
                  name: 'donation-templeList',
                  builder: (context, state) {
                    return const TempleListScreen();
                  },
                ),
              ],
            ),
          ],
        ),

        // ------------------------------------------------------
        // PANDITS / ASTROLOGY
        // ------------------------------------------------------
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/main/pandits',
              name: 'pandits',
              builder: (context, state) {
                return BlocProvider<PanditBloc>(
                  create: (_) => getIt<PanditBloc>(),
                  child: const PanditsPage(),
                );
              },

              routes: [
                GoRoute(
                  path: 'pandit/:id',
                  name: 'pandit-detail',
                  builder: (context, state) {
                    final panditId = state.pathParameters['id'];
                    return _PlaceholderPage(title: 'Pandit: $panditId');
                  },
                ),
              ],
            ),
          ],
        ),

        // ------------------------------------------------------
        // STORE / SHOP
        // ------------------------------------------------------
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/main/store',
              name: 'store',
              builder: (context, state) {
                return BlocProvider<StoreHomeBloc>(
                  create: (_) => getIt<StoreHomeBloc>()..add(LoadStoreHome()),
                  child: const StoreHomePage(),
                );
              },

              routes: [
                GoRoute(
                  path: 'product/:productId',
                  name: 'product-detail',
                  builder: (context, state) {
                    final productId = state.pathParameters['productId']!;
                    // final productId = state.pathParameters['id'];
                    return ProductDetailPage(productId: productId);
                  },
                ),

                GoRoute(
                  path: 'cart',
                  name: 'cart',
                  builder: (context, state) {
                    return const CartPage();
                  },
                  routes: [
                    GoRoute(
                      path: 'cart/Coupon',
                      name: 'cart-Coupon',
                      builder: (context, state) {
                        return const StoreCouponScreen();
                      },
                    ),

                    GoRoute(
                      path: 'addresses',
                      name: 'saved-address',
                      builder: (context, state) {
                        return BlocProvider(
                          create: (_) => getIt<AddressBloc>()..add(const LoadAddresses()),
                          child: const SavedAddressPage(),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'addresses/add',
                      name: 'add-address',
                      builder: (context, state) {
                        return BlocProvider(
                          create: (_) => getIt<AddressBloc>(),
                          child: const AddAddressPage(),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'cart/address',
                      name: 'cart-address',
                      builder: (context, state) {
                        return const SavedAddressesScreen();
                      },
                    ),
                  ],
                ),

                GoRoute(
                  path: 'checkout',
                  name: 'checkout',
                  builder: (context, state) {
                    return const _PlaceholderPage(title: 'Checkout');
                  },
                ),

                GoRoute(
                  path: 'payment',
                  name: 'payment',
                  builder: (context, state) {
                    return const  StorePaymentScreen();
                  },

                  routes: [
                    GoRoute(
                      path: 'success',
                      name: 'payment-success',
                      builder: (context, state) {
                        return const _PlaceholderPage(title: 'Payment Successful',
                        );
                      },
                    ),

                    GoRoute(
                      path: 'failed',
                      name: 'payment-failed',
                      builder: (context, state) {
                        return const _PlaceholderPage(title: 'Payment Failed');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // ------------------------------------------------------
        // PROFILE
        // ------------------------------------------------------
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/main/profile',
              name: 'profile',
              builder: (context, state) {
                return BlocProvider<ProfileBloc>(
                  create: (_) =>
                      getIt<ProfileBloc>()..add(GetProfileDetailsEvent()),
                  child: const ProfilePage(),
                );
              },
            ),
          ],
        ),

        // ------------------------------------------------------
        // POOJA
        // ------------------------------------------------------
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/main/pooja',
              name: 'pooja',
              builder: (context, state) {
                return BlocProvider<PoojaBloc>(
                  create: (_) => getIt<PoojaBloc>(),
                  child: const PoojaListPage(),
                );
              },

              routes: [
                GoRoute(
                  path: 'detail/:id',
                  name: 'pooja-detail',
                  builder: (context, state) {
                    final poojaId = state.pathParameters['id'];
                    return _PlaceholderPage(title: 'Pooja Detail: $poojaId');
                  },
                ),

                GoRoute(
                  path: 'detail/:id/booking',
                  name: 'pooja-booking',
                  builder: (context, state) {
                    final poojaId = state.pathParameters['id'];
                    return _PlaceholderPage(title: 'Pooja Booking: $poojaId');
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],

  // ------------------------------------------------------------
  // 404 PAGE
  // ------------------------------------------------------------
  errorBuilder: (context, state) {
    return const _PlaceholderPage(title: 'Page Not Found');
  },
);

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
