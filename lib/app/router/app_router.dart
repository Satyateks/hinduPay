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
import '../../features/astrologer/domain/entities/astrologer.dart';
import '../../features/astrologer/presentation/bloc/astrologer_bloc.dart';
import '../../features/astrologer/presentation/bloc/astrologer_event.dart';
import '../../features/astrologer/presentation/pages/astrologer_list_page.dart';
import '../../features/astrologer/presentation/pages/astrologer_profile_page.dart';
import '../../features/horoscope/presentation/bloc/horoscope_bloc.dart';
import '../../features/horoscope/presentation/bloc/horoscope_event.dart';
import '../../features/horoscope/presentation/pages/horoscope_page.dart';
import '../../features/pandit/domain/entities/pandit.dart';
import '../../features/pandit/presentation/bloc/pandit_bloc.dart';
import '../../features/pandit/presentation/bloc/pandit_event.dart';
import '../../features/pandit/presentation/pages/pandit_booking_page.dart';
import '../../features/pandit/presentation/pages/pandit_cart_page.dart';
import '../../features/pandit/presentation/pages/pandit_page.dart';
import '../../features/payments/domain/entities/payment.dart';
import '../../features/payments/presentation/pages/add_beneficiary_page.dart';
import '../../features/payments/presentation/pages/bank_transfer_page.dart';
import '../../features/payments/presentation/pages/mobile_pay_page.dart';
import '../../features/payments/presentation/pages/payment_status_page.dart';
import '../../features/payments/presentation/pages/payments_page.dart';
import '../../features/payments/presentation/pages/scan_pay_page.dart';
import '../../features/payments/presentation/pages/send_money_page.dart';
import '../../features/payments/presentation/pages/transaction_history_page.dart';
import '../../features/payments/presentation/pages/upi_pin_page.dart';
import '../../features/payments/presentation/pages/upi_settings_page.dart';
import '../../features/pooja/presentation/bloc/pooja_bloc.dart';
import '../../features/pooja/presentation/pages/pooja_list_page.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_event.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

import '../../features/store/domain/entities/cart.dart';
import '../../features/store/domain/entities/store_order.dart';
import '../../features/store/presentation/bloc/address/address_bloc.dart';
import '../../features/store/presentation/bloc/address/address_event.dart';
import '../../features/store/presentation/bloc/store_home/store_home_bloc.dart';
import '../../features/store/presentation/bloc/store_home/store_home_event.dart';
import '../../features/store/presentation/pages/checkout_page.dart';
import '../../features/store/presentation/pages/coupon_page.dart';
import '../../features/store/presentation/pages/product_detail_page.dart';
import '../../features/store/presentation/pages/product_reviews_page.dart';
import '../../features/store/presentation/pages/store_home_page.dart';
import '../../features/store/presentation/pages/wishlist_page.dart';
import '../../features/store/presentation/widgets/order_details.dart';
import '../../features/store/presentation/widgets/order_list.dart';
import '../../features/store/presentation/widgets/order_success.dart';
import '../../features/store/presentation/widgets/price_summary.dart';
import '../../features/store/presentation/widgets/product_address_page.dart';
import '../../features/store/presentation/widgets/support_help.dart';
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
    // UPI SUBMODULE ROUTES
    // ----------------------------------------------------------
    GoRoute(
      path: '/upi/history',
      name: 'upi-history',
      builder: (context, state) => const TransactionHistoryPage(),
    ),

    GoRoute(
      path: '/upi/scan',
      name: 'upi-scan',
      builder: (context, state) => const ScanPayPage(),
    ),

    GoRoute(
      path: '/upi/settings',
      name: 'upi-settings',
      builder: (context, state) => const UpiSettingsPage(),
    ),

    GoRoute(
      path: '/upi/mobile',
      name: 'upi-mobile',
      builder: (context, state) => const MobilePayPage(),
    ),

    GoRoute(
      path: '/upi/bank',
      name: 'upi-bank',
      builder: (context, state) => const BankTransferPage(),
    ),

    GoRoute(
      path: '/upi/bank/add',
      name: 'upi-bank-add',
      builder: (context, state) => const AddBeneficiaryPage(),
    ),

    GoRoute(
      path: '/upi/pay',
      name: 'upi-pay',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return SendMoneyPage(
          recipientName: extra?['name'] as String?,
          recipientPhone: extra?['phone'] as String?,
          initialAmount: (extra?['amount'] as num?)?.toDouble(),
          initialNote: extra?['note'] as String?,
        );
      },
    ),

    GoRoute(
      path: '/upi/pin',
      name: 'upi-pin',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return UpiPinPage(
          recipientName: extra?['name'] as String?,
          recipientPhone: extra?['phone'] as String?,
          amount: (extra?['amount'] as num?)?.toDouble(),
          note: extra?['note'] as String?,
          bankName: extra?['bankName'] as String?,
          maskedAccount: extra?['maskedAccount'] as String?,
        );
      },
    ),

    GoRoute(
      path: '/upi/status',
      name: 'upi-status',
      builder: (context, state) {
        final payment = state.extra as Payment?;
        return PaymentStatusPage(payment: payment);
      },
    ),

    // ----------------------------------------------------------
    // HOROSCOPE
    // ----------------------------------------------------------
    GoRoute(
      path: '/main/horoscope',
      name: 'horoscope',
      builder: (context, state) {
        return BlocProvider<HoroscopeBloc>(
          create: (_) => getIt<HoroscopeBloc>()..add(const LoadHoroscope()),
          child: const HoroscopePage(),
        );
      },
    ),

    // ----------------------------------------------------------
    // PANDITS (BOOKING FLOW FROM HOME QUICK ACTION)
    // ----------------------------------------------------------
    GoRoute(
      path: '/main/pandits',
      name: 'pandits',
      builder: (context, state) {
        return BlocProvider<PanditBloc>(
          create: (_) => getIt<PanditBloc>()..add(const LoadPoojaServicesEvent()),
          child: const PanditsPage(),
        );
      },
      routes: [
        GoRoute(
          path: 'booking',
          name: 'pandit-booking',
          builder: (context, state) {
            final service = state.extra as PanditPoojaService;
            return BlocProvider<PanditBloc>(
              create: (_) => getIt<PanditBloc>()..add(InitBookingFlowEvent(service)),
              child: PanditBookingPage(service: service),
            );
          },
        ),
        GoRoute(
          path: 'cart',
          name: 'pandit-cart',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return BlocProvider<PanditBloc>(
              create: (_) => getIt<PanditBloc>()..add(LoadSamagriEvent(service: extra?['service'] as PanditPoojaService?)),
              child: PanditCartPage(bookingData: extra),
            );
          },
        ),
      ],
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
        // ASTROLOGERS / ASTROLOGY (TAB 1)
        // ------------------------------------------------------
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/main/astrologers',
              name: 'astrologers',
              builder: (context, state) {
                return BlocProvider<AstrologerBloc>(
                  create: (_) =>
                      getIt<AstrologerBloc>()..add(const LoadAstrologers()),
                  child: const AstrologerListPage(),
                );
              },
              routes: [
                GoRoute(
                  path: 'horoscope',
                  name: 'astrologers-horoscope',
                  builder: (context, state) {
                    return BlocProvider<HoroscopeBloc>(
                      create: (_) =>
                          getIt<HoroscopeBloc>()..add(const LoadHoroscope()),
                      child: const HoroscopePage(),
                    );
                  },
                ),
                GoRoute(
                  path: 'profile/:id',
                  name: 'astrologer-profile',
                  builder: (context, state) {
                    final astrologerId = state.pathParameters['id']!;
                    final extra = state.extra;
                    Astrologer? initialAstrologer;
                    AstrologerBloc? existingBloc;

                    if (extra is Map<String, dynamic>) {
                      final candidateAstrologer = extra['astrologer'];
                      final candidateBloc = extra['bloc'];
                      if (candidateAstrologer is Astrologer) {
                        initialAstrologer = candidateAstrologer;
                      }
                      if (candidateBloc is AstrologerBloc) {
                        existingBloc = candidateBloc;
                      }
                    } else if (extra is Astrologer) {
                      initialAstrologer = extra;
                    }

                    final page = AstrologerProfilePage(
                      astrologerId: astrologerId,
                      initialAstrologer: initialAstrologer,
                    );

                    if (existingBloc != null) {
                      return BlocProvider<AstrologerBloc>.value(
                        value: existingBloc,
                        child: page,
                      );
                    }

                    return BlocProvider<AstrologerBloc>(
                      create: (_) =>
                          getIt<AstrologerBloc>()
                            ..add(LoadAstrologerProfile(astrologerId)),
                      child: page,
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        // ------------------------------------------------------
        // UPI DASHBOARD (TAB 2 - CENTER ACTIVE TAB)
        // ------------------------------------------------------
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/main/upi',
              name: 'upi',
              builder: (context, state) {
                return const PaymentsPage();
              },
            ),
          ],
        ),

        // ------------------------------------------------------
        // DONATION / DAAN (TAB 3)
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
                  path: 'product/:productId/reviews',
                  name: 'product-reviews',
                  builder: (context, state) {
                    return ProductReviewsPage(productId: state.pathParameters['productId']!);
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
                      path: 'coupon',
                      name: 'coupon',
                      builder: (context, state) {
                        final extra = state.extra;
                        final orderAmount = extra is double ? extra : 0.0;
                        return CouponPage(orderAmount: orderAmount);
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
                      builder: (context, state) {return const SavedAddressesScreen();},
                    ),
                  ],
                ),

                GoRoute(
                  path: 'checkout',
                  name: 'checkout',
                  builder: (context, state) {
                    final cart = state.extra;
                    if (cart is! Cart) return const Scaffold(body: Center(child: Text('Checkout details are missing. Please reopen your cart.')));
                    return CheckoutPage(cart: cart);
                  },
                ),
                GoRoute(
                  path: 'wishlist',
                  name: 'wishlist',
                  builder: (context, state) => const WishlistPage(),
                ),
                
                GoRoute(
                  path: 'order-success',
                  name: 'order-success',
                  builder: (context, state) {
                    final order = state.extra;
                    if (order is! StoreOrder) return const Scaffold(body: Center(child: Text('Order details are unavailable.')));
                      return OrderSuccessPage(order: order);
                  },
                ),
                GoRoute(
                  path: 'orders',
                  name: 'order-list',
                  builder: (context, state) => const OrderList(),
                  routes: [
                    GoRoute(
                      path: ':orderId',
                      name: 'order-details',
                      builder: (context, state) {return OrderDetails(orderId: state.pathParameters['orderId']!);},
                    ),
                  ],
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
           
                GoRoute(
                  path: 'help-support',
                  name: 'help-support',
                  builder: (context, state) => const HelpSupportPage(),
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
