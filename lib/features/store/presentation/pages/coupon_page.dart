import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/coupon.dart';
import '../bloc/coupon/coupon_bloc.dart';
import '../bloc/coupon/coupon_event.dart';
import '../bloc/coupon/coupon_state.dart';

class CouponPage extends StatelessWidget {
  final double orderAmount;
  const CouponPage({super.key, required this.orderAmount});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CouponBloc>()..add(const LoadCoupons()),
      child: _CouponView(orderAmount: orderAmount),
    );
  }
}

class _CouponView extends StatefulWidget {
  final double orderAmount;
  const _CouponView({required this.orderAmount});

  @override
  State<_CouponView> createState() => _CouponViewState();
}

class _CouponViewState extends State<_CouponView> {
  final TextEditingController _codeController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _applyCoupon(List<Coupon> coupons, String code) {
    final normalizedCode = code.trim().toUpperCase();

    if (normalizedCode.isEmpty) {
      setState(() => _error = 'Please enter a coupon code');
      return;
    }

    Coupon? selected;
    for (final coupon in coupons) {
      if (coupon.code.toUpperCase() == normalizedCode) {
        selected = coupon;
        break;
      }
    }

    if (selected == null || !selected.isActive) {
      setState(() => _error = 'Invalid or unavailable coupon');
      return;
    }

    if (widget.orderAmount < selected.minOrderValue) {
      setState(() => _error = 'Minimum order value is ₹${selected?.minOrderValue.toStringAsFixed(0)}');
      return;
    }

    final discount = selected.calculateDiscount(widget.orderAmount);

    if (discount <= 0) {
      setState(() => _error = 'This coupon cannot be applied to your order');
      return;
    }

    context.pop(CouponApplication(coupon: selected, discount: discount));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(title: const Text('Apply Coupon')),
      body: BlocBuilder<CouponBloc, CouponState>(
        builder: (context, state) {
          if (state.status == CouponStatus.loading || state.status == CouponStatus.initial) return const Center(child: CircularProgressIndicator());
          if (state.status == CouponStatus.failure) return Center(child: Text(state.errorMessage ?? 'Unable to load coupons'));
          
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _codeController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              hintText: 'Enter coupon code',
                              border: const OutlineInputBorder(),
                              errorText: _error,
                            ),
                            onChanged: (_) { if (_error != null) setState(() => _error = null); },
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () => _applyCoupon(state.coupons, _codeController.text),
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Order value: ₹${widget.orderAmount.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.coupons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final coupon = state.coupons[index];
                    final eligible = widget.orderAmount >= coupon.minOrderValue;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              // Left Green Stub with Vertical "DISCOUNT" and Notch
                              Container(height: 150,
                                width: 50,
                                color: const Color(0xFF00C853), // Vibrant Green
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Text(
                                        'DISCOUNT',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    // Left semicircular cutout effect
                                    Positioned(
                                      left: -10,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF8F9FA), // Matches Scaffold background
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Right Content Section
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            coupon.title, // e.g., "Flat ₹25 off*"
                                            style: const TextStyle(
                                              color: Color(0xFF00C853),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          // Radio/Checkbox indicator style from image
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.grey.shade300),
                                            ),
                                            child: Center(
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: eligible ? Colors.orange : Colors.transparent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        coupon.code, // e.g., "FINFIRST25"
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        coupon.description,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        '*Terms & conditions',
                                        style: TextStyle(
                                          color: Color(0xFF3F51B5), // Blue shade for T&C
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      
                                      // Apply Code Button
                                      SizedBox(
                                        width: double.infinity,
                                        height: 36,
                                        child: ElevatedButton(
                                          onPressed: eligible
                                              ? () => _applyCoupon(state.coupons, coupon.code)
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFD4EDDA),
                                            foregroundColor: const Color(0xFF155724),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(18),
                                            ),
                                          ),
                                          child: const Text(
                                            'Apply Code',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      if (!eligible) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          'Add items worth ₹${(coupon.minOrderValue - widget.orderAmount).toStringAsFixed(0)} more to use this coupon.',
                                          style: TextStyle(color: colors.error, fontSize: 11),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
       /*       Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.coupons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final coupon = state.coupons[index];
                    final eligible = widget.orderAmount >= coupon.minOrderValue;

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.confirmation_number_outlined,
                                  color: colors.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    coupon.code,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextButton(
                                  onPressed: eligible
                                      ? () => _applyCoupon(
                                          state.coupons,
                                          coupon.code,
                                        )
                                      : null,
                                  child: const Text('APPLY'),
                                ),
                              ],
                            ),
                            Text(
                              coupon.title,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(coupon.description),
                            if (!eligible) ...[
                              const SizedBox(height: 6),
                              Text(
                                'Add items worth ₹${(coupon.minOrderValue - widget.orderAmount).toStringAsFixed(0)} more to use this coupon.',
                                style: TextStyle(color: colors.error),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
     */
            ],
          );
        },
      ),
    );
  }
}
