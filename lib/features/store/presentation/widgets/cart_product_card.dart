import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/coupon.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final String name;
  final String image;
  final double price;

  const ProductCard({
    super.key,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        context.pushNamed('product-detail',pathParameters: {'productId': productId});
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),

            const SizedBox(height: 8),
            Text(
              '$name   ProductCard',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 4),

            Text(
              '₹${price.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CouponCard extends StatelessWidget {
  final Cart cart;
  const CouponCard({super.key, required this.cart});

  Future<void> openCouponPage(BuildContext context, double orderAmount) async {
    final application = await context.pushNamed<CouponApplication>('coupon',extra: orderAmount);
    if (!context.mounted || application == null) return;
    context.read<CartBloc>().add(ApplyCartCoupon(couponCode: application.coupon.code,couponDiscount: application.discount));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCouponApplied = cart.appliedCouponCode != null;

    return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.percent, color: Color(0xFF0C8346)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Apply Coupon',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                  ),
                ),
              ),
              if (!isCouponApplied)
                IconButton(
                  onPressed: ()=>openCouponPage(context, cart.subtotal - cart.discount),
                  icon:Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black54),
                ),
            ],
          ),
          if (isCouponApplied) ...[
            const Divider(),
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(child: Text('Applied: ${cart.appliedCouponCode}',style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
                TextButton(
                  onPressed: () =>context.read<CartBloc>().add(const RemoveCartCoupon()),
                  child: const Text('Remove'),
                ),
              ],
            ),
            Text('Coupon discount: -₹${cart.couponDiscount.toStringAsFixed(0)}',style: theme.textTheme.bodySmall?.copyWith(color: Colors.green)),
          ],
        ],
      ),
    );
  }
}
