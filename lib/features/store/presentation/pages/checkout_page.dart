import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/store_order.dart';
import '../../domain/entities/cart.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../bloc/checkout/checkout_event.dart';
import '../bloc/checkout/checkout_state.dart';

class CheckoutPage extends StatelessWidget {
  final Cart cart;

  const CheckoutPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CheckoutBloc>(),
      child: _CheckoutView(cart: cart),
    );
  }
}

class _CheckoutView extends StatefulWidget {
  final Cart cart;

  const _CheckoutView({required this.cart});

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  StorePaymentMethod _paymentMethod = StorePaymentMethod.upi;
  bool _submitted = false;

  String get _paymentLabel {
    switch (_paymentMethod) {
      case StorePaymentMethod.upi:
        return 'UPI';
      case StorePaymentMethod.card:
        return 'Credit / Debit Card';
      case StorePaymentMethod.cashOnDelivery:
        return 'Cash on Delivery';
    }
  }

  void _placeOrder() {
    final cart = widget.cart;
    final address = cart.deliveryAddress;

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty')));
      return;
    }

    if (address == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      context.pushNamed('saved-address');
      return;
    }

    if (cart.total <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please check the order total')),
      );
      return;
    }

    setState(() => _submitted = true);

    context.read<CheckoutBloc>().add(
      PlaceStoreOrder(
        productNames: cart.items.map((item) => item.name).toList(),
        addressName: address.name,
        deliveryAddress:
            '${address.address}, ${address.city}, ${address.state} - ${address.pincode}',
        phone: address.phone,
        totalAmount: cart.total,
        paymentMethod: _paymentMethod,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final cart = widget.cart;
    final address = cart.deliveryAddress;

    return BlocListener<CheckoutBloc, CheckoutState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == CheckoutStatus.success && state.order != null) {
          context.goNamed('order-success', extra: state.order);
        } else if (state.status == CheckoutStatus.failure) {
          setState(() => _submitted = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Could not place order'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: cart.items.isEmpty
            ? const Center(child: Text('Your cart is empty'))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('Delivery Address',style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: address == null
                          ? Row(
                              children: [
                                const Expanded(child: Text('No delivery address selected')),
                                TextButton(
                                  onPressed: () =>context.pushNamed('saved-address'),
                                  child: const Text('Select'),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(address.phone),
                                const SizedBox(height: 4),
                                Text('${address.address}, ${address.city}, ${address.state} - ${address.pincode}'),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () =>context.pushNamed('saved-address'),
                                    child: const Text('Change'),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Order Summary (${cart.items.length} items)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          for (final item in cart.items)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(child: Text('${item.name} × ${item.quantity}')),
                                  Text('₹${item.itemTotal.toStringAsFixed(0)}'),
                                ],
                              ),
                            ),
                          const Divider(),
                          _PriceRow(label: 'Subtotal', amount: cart.subtotal),
                          _PriceRow(label: 'Product discount',amount: -cart.discount,valueColor: colors.primary),
                          _PriceRow(label: 'Coupon discount',amount: -cart.couponDiscount,valueColor: colors.primary),
                          _PriceRow(label: 'Delivery',amount: cart.deliveryCharge),
                          const Divider(),
                          _PriceRow(label: 'Total payable',amount: cart.total,bold: true),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Payment Method',style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: [
                        RadioListTile<StorePaymentMethod>(
                          value: StorePaymentMethod.upi,
                          groupValue: _paymentMethod,
                          onChanged: (value) =>setState(() => _paymentMethod = value!),
                          title: const Text('UPI'),
                          secondary: const Icon(Icons.account_balance),
                        ),
                        RadioListTile<StorePaymentMethod>(
                          value: StorePaymentMethod.card,
                          groupValue: _paymentMethod,
                          onChanged: (value) =>setState(() => _paymentMethod = value!),
                          title: const Text('Credit / Debit Card'),
                          secondary: const Icon(Icons.credit_card),
                        ),
                        RadioListTile<StorePaymentMethod>(
                          value: StorePaymentMethod.cashOnDelivery,
                          groupValue: _paymentMethod,
                          onChanged: (value) =>setState(() => _paymentMethod = value!),
                          title: const Text('Cash on Delivery'),
                          secondary: const Icon(Icons.payments_outlined),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Selected: $_paymentLabel',style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
        bottomNavigationBar: cart.items.isEmpty
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BlocBuilder<CheckoutBloc, CheckoutState>(
                    builder: (context, state) {
                      final loading = state.status == CheckoutStatus.submitting;
                      return SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: loading || _submitted ? null : _placeOrder,
                          child: loading
                              ? const SizedBox(height: 22,width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                              : Text('Place Order • ₹${cart.total.toStringAsFixed(0)}'),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool bold;
  final Color? valueColor;

  const _PriceRow({
    required this.label,
    required this.amount,
    this.bold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    final value = '${amount < 0 ? '-' : ''}₹${amount.abs().toStringAsFixed(0)}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: bold
                  ? style?.copyWith(fontWeight: FontWeight.bold)
                  : style,
            ),
          ),
          Text(
            value,
            style: (bold ? style?.copyWith(fontWeight: FontWeight.bold) : style)
                ?.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
