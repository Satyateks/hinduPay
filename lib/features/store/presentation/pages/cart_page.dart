import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'My Cart - Puja Thali Set',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
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
                  SizedBox(width: double.infinity,
                    child: ElevatedButton(
                      onPressed: ()=> context.read<CartBloc>().add(const LoadCart()),
                      child: const Text('Retry'),
                    ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    children: [
                      _DeliveryAddressCard(address: cart.deliveryAddress),
                      const SizedBox(height: 12),
                      ...cart.items.map((item) => _CartProductCard(item: item)),
                      const SizedBox(height: 16),
                      const Text(
                        'Price details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _PriceDetails(cart: cart),
                      const SizedBox(height: 20),
                      const _SecurePaymentCard(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                      color: Colors.black.withValues(alpha: 0.05),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Payable amount  ',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            '₹${cart.total.toStringAsFixed(0)}  ',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF097939),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              elevation: 0,
                            ),
                            onPressed: cart.items.isEmpty || cart.deliveryAddress == null
                                ? null
                                : () {context.pushNamed('checkout', extra: cart);},
                            child: const Text('Proceed to buy',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
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
    if (address == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Color(0xFF0C8346), size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${address!.address}, ${address!.city}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => context.pushNamed('saved-address'),
            child: const Text(
              'Change',
              style: TextStyle(
                color: Color(0xFF0C8346),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        item.image,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            width: 110,
                            height: 110,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.shopping_bag_outlined),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Lorem ipsum dolor sit amet consectetur.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '₹ ${item.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '29% OFF',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0C8346),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF0C8346)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<CartBloc>().add(
                                      ChangeCartQuantity(
                                        cartItemId: item.id,
                                        quantity: item.quantity - 1,
                                      ),
                                    );
                              },
                              child: const Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Color(0xFF0C8346),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.read<CartBloc>().add(
                                      ChangeCartQuantity(
                                        cartItemId: item.id,
                                        quantity: item.quantity + 1,
                                      ),
                                    );
                              },
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: Color(0xFF0C8346),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.local_shipping_outlined, size: 16, color: Colors.blue),
                const SizedBox(width: 6),
                const Text(
                  'Delivery by 4 Feb 2026',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  '(2 days)',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: const [
                Icon(Icons.percent, size: 18, color: Color(0xFF0C8346)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Select Coupon',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black54),
              ],
            ),
          ),
          const SizedBox(height: 6),
          CouponCard(cart: cart),
          const SizedBox(height: 12),
          _PriceRow(
            title: 'Price (${cart.items.length} item)',
            value: '₹${cart.subtotal.toStringAsFixed(0)}',
          ),
          _PriceRow(
            title: 'Discount',
            value: '-₹${cart.discount.toStringAsFixed(0)}',
          ),
          const Divider(color: Color(0xFFEEEEEE)),
          _PriceRow(
            title: 'Grand total',
            subtitle: 'Including GST',
            value: '₹${cart.total.toStringAsFixed(0)}',
            valueColor: const Color(0xFF0C8346),
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String value;
  final bool bold;
  final Color? valueColor;

  const _PriceRow({
    required this.title,
    this.subtitle,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? Colors.black87,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.check_circle, size: 18, color: Color(0xFF0C8346)),
        SizedBox(width: 6),
        Text(
          'Safe and secure payments. Easy return.',
          style: TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}


 /*
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

    return Scaffold(backgroundColor:const Color(0xFFFAFAFA),
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
                      CouponCard(cart: cart),
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

                       FilledButton(//onPressed: ()=> context.pushNamed('payment'),
                        onPressed: cart.items.isEmpty || cart.deliveryAddress == null ? null : () {context.pushNamed('checkout',extra: cart);},
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
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text('${address!.name} • ${address!.phone}',style: theme.textTheme.bodySmall),
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
            onPressed: ()=> context.pushNamed('saved-address'),
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

*/



































