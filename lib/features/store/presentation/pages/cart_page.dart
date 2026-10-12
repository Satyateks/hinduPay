import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hindu_pay/app/theme/app_colors.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/cart.dart';

import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';
import '../widgets/cart_product_card.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CartBloc>()..add(const LoadCart()),
      child: const CartView(),
    );
  }
}

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.status == CartStatus.initial || state.status == CartStatus.loading) return const Center(child: CircularProgressIndicator());
          

          if (state.status == CartStatus.failure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? 'Something went wrong'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(const LoadCart());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final cart = state.cart;
          if (cart == null || cart.items.isEmpty) return const Center(child: Text('Your cart is empty'));
          

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<CartBloc>().add(const RefreshCart());
                  },
                  child: ListView(
                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                    children: [
                      _DeliveryAddressCard(address: cart.deliveryAddress),
                      const SizedBox(height: 8),
                      ...cart.items.map((item) => _CartProductCard(item: item)),
                      CouponCard(),
                      _PriceDetails(cart: cart),
                      _SecurePaymentCard(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      offset: const Offset(0, -3),
                      color: colors.shadow.withValues(alpha: 0.10),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Amount',
                              style: theme.textTheme.labelMedium,
                            ),
                            Text(
                              '₹${cart.total.toStringAsFixed(0)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                        onPressed: () {context.pushNamed('payment');},
                        child: const Text('Proceed to Buy'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

 
class _DeliveryAddressCard extends StatelessWidget {
  final CartAddress? address;
  const _DeliveryAddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (address == null) return const SizedBox.shrink();
    

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on_outlined, color: colors.primary),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Address',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${address!.name} • ${address!.phone}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 2),
                Text(
                  '${address!.address}, '
                  '${address!.city}, '
                  '${address!.state} - '
                  '${address!.pincode}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: () {
             context.pushNamed('saved-address');
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}

class _CartProductCard extends StatelessWidget {
  final CartItem item;

  const _CartProductCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.asset(
              item.image,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 90,
                  height: 90,
                  color: colors.surfaceContainerHighest,
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: colors.primary,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '₹${item.price.toStringAsFixed(0)}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        context.read<CartBloc>().add(
                          ChangeCartQuantity(
                            cartItemId: item.id,
                            quantity: item.quantity - 1,
                          ),
                        );
                      },
                      icon: const Icon(Icons.remove, size: 18),
                    ),

                    Text(
                      '${item.quantity}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        context.read<CartBloc>().add(
                          ChangeCartQuantity(
                            cartItemId: item.id,
                            quantity: item.quantity + 1,
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                    ),

                    const Spacer(),

                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        context.read<CartBloc>().add(
                          RemoveCartItem(cartItemId: item.id),
                        );
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: colors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurePaymentCard extends StatelessWidget {
  const _SecurePaymentCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 16, color: colors.primary),
          const SizedBox(width: 5),
          Text('Safe & Secure Payments', style: theme.textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _PriceDetails extends StatelessWidget {
  final Cart cart;

  const _PriceDetails({required this.cart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Details',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          _PriceRow(
            title: 'Price',
            value: '₹${cart.subtotal.toStringAsFixed(0)}',
          ),

          _PriceRow(
            title: 'Discount',
            value: '-₹${cart.discount.toStringAsFixed(0)}',
          ),

          _PriceRow(
            title: 'Delivery',
            value: cart.deliveryCharge == 0
                ? 'FREE'
                : '₹${cart.deliveryCharge.toStringAsFixed(0)}',
          ),

          _PriceRow(
            title: 'Coupon Discount',
            value: '-₹${cart.couponDiscount.toStringAsFixed(0)}',
          ),

          const Divider(),

          _PriceRow(
            title: 'Total Amount',
            value: '₹${cart.total.toStringAsFixed(0)}',
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String title;
  final String value;
  final bool bold;

  const _PriceRow({
    required this.title,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: bold ? FontWeight.w700 : null,  color:bold? AppColors.primaryGreen:null);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
