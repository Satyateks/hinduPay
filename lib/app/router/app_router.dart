import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/pandit/presentation/bloc/pandit_bloc.dart';
import '../../features/pandit/presentation/pages/pandit_page.dart';
import '../../features/pooja/presentation/bloc/pooja_bloc.dart';
import '../../features/pooja/presentation/pages/pooja_list_page.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_event.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',

    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) {
          return BlocProvider<AuthBloc>(
            // GetIt se bloc create karke dein
            create: (context) => getIt<AuthBloc>(),
            child: const SplashPage(),
          );
        },
      ),

      // Authentication
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<AuthBloc>(),
            child: const LoginPage(),
          );
        },
      ),

      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) {
          // final mobile = state.uri.queryParameters['mobile'] ?? '';
          final mobile = state.extra as String? ?? '';
          return BlocProvider(
            create: (_) => getIt<AuthBloc>(),
            child: OtpPage(mobile: mobile),
          );
        },
      ),

      // Home
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<HomeBloc>(),
            child: const HomePage(),
          );
        },
      ),

      // Pooja
      GoRoute(
        path: '/pooja',
        name: 'pooja',
        builder: (context, state) {
         return BlocProvider(
            create: (_) => getIt<PoojaBloc>(),
            child: const PoojaListPage(),
          );
        },
      ),

      GoRoute(
        path: '/pooja/:id',
        name: 'pooja-detail',
        builder: (context, state) {
          final poojaId = state.pathParameters['id'];

          return _PlaceholderPage(title: 'Pooja Detail: $poojaId');
        },
      ),

      GoRoute(
        path: '/pooja/:id/booking',
        name: 'pooja-booking',
        builder: (context, state) {
          final poojaId = state.pathParameters['id'];

          return _PlaceholderPage(title: 'Pooja Booking: $poojaId');
        },
      ),

      // Shop
      GoRoute(
        path: '/shop',
        name: 'shop',
        builder: (context, state) {
          return const _PlaceholderPage(title: 'Shop');
        },
      ),

      GoRoute(
        path: '/product/:id',
        name: 'product-detail',
        builder: (context, state) {
          final productId = state.pathParameters['id'];

          return _PlaceholderPage(title: 'Product: $productId');
        },
      ),

      // Cart
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) {
          return const _PlaceholderPage(title: 'Cart');
        },
      ),

      // Checkout
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) {
          return const _PlaceholderPage(title: 'Checkout');
        },
      ),

      // Payment
      GoRoute(
        path: '/payment',
        name: 'payment',
        builder: (context, state) {
          return const _PlaceholderPage(title: 'Payment');
        },
      ),

      GoRoute(
        path: '/payment/success',
        name: 'payment-success',
        builder: (context, state) {
          return const _PlaceholderPage(title: 'Payment Successful');
        },
      ),

      GoRoute(
        path: '/payment/failed',
        name: 'payment-failed',
        builder: (context, state) {
          return const _PlaceholderPage(title: 'Payment Failed');
        },
      ),

      // Orders
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) {
          return const _PlaceholderPage(title: 'Orders');
        },
      ),

      GoRoute(
        path: '/order/:id',
        name: 'order-detail',
        builder: (context, state) {
          final orderId = state.pathParameters['id'];

          return _PlaceholderPage(title: 'Order: $orderId');
        },
      ),

      // Temple
      GoRoute(
        path: '/temples',
        name: 'temples',
        builder: (context, state) {
          return const _PlaceholderPage(title: 'Temples');
        },
      ),

      GoRoute(
        path: '/temple/:id',
        name: 'temple-detail',
        builder: (context, state) {
          final templeId = state.pathParameters['id'];

          return _PlaceholderPage(title: 'Temple: $templeId');
        },
      ),

      // Darshan
      GoRoute(
        path: '/darshan',
        name: 'darshan',
        builder: (context, state) {
          return const _PlaceholderPage(title: 'Darshan');
        },
      ),

      GoRoute(
        path: '/darshan/booking',
        name: 'darshan-booking',
        builder: (context, state) {
          return const _PlaceholderPage(title: 'Darshan Booking');
        },
      ),

      // Pandit
      GoRoute(
        path: '/pandits',
        name: 'pandits',
        builder: (context, state) {
        return BlocProvider(create: (_) => getIt<PanditBloc>(), child: const PanditsPage());
        },
      ),

      GoRoute(
        path: '/pandit/:id',
        name: 'pandit-detail',
        builder: (context, state) {
          final panditId = state.pathParameters['id'];

          return _PlaceholderPage(title: 'Pandit: $panditId');
        },
      ),

      // Donation
      GoRoute(
        path: '/donation',
        name: 'donation',
        builder: (context, state) {
          return const _PlaceholderPage(title: 'Donation');
        },
      ),

      // Profile
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<ProfileBloc>()..add(GetProfileDetailsEvent()),
            child: const ProfilePage(),
          );
        },
      ),

    ],

    // 404
    errorBuilder: (context, state) {
      return const _PlaceholderPage(title: 'Page Not Found');
    },
  );
}

/// Temporary page.
///
/// Isko baad me actual screens se replace kar denge.
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



/*Updated code 

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',

    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<AuthBloc>(),
            child: const SplashPage(),
          );
        },
      ),

      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<AuthBloc>(),
            child: const LoginPage(),
          );
        },
      ),

      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) {
          final mobile =
              state.uri.queryParameters['mobile'] ?? '';

          return BlocProvider(
            create: (_) => getIt<AuthBloc>(),
            child: OtpPage(
              mobile: mobile,
            ),
          );
        },
      ),

      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) {
          return const Scaffold(
            body: Center(
              child: Text('Home'),
            ),
          );
        },
      ),
    ],

    errorBuilder: (
      context,
      state,
    ) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Page Not Found',
          ),
        ),
      );
    },
  );
}
*/






