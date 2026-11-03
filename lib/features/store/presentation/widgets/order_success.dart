import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/store_order.dart';

class OrderSuccessPage extends StatelessWidget {
  final StoreOrder order;

  const OrderSuccessPage({super.key, required this.order});

  String get _paymentLabel {
    switch (order.paymentMethod) {
      case StorePaymentMethod.upi:
        return 'UPI';
      case StorePaymentMethod.card:
        return 'Credit / Debit Card';
      case StorePaymentMethod.cashOnDelivery:
        return 'Cash on Delivery';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final paymentPending = order.status == StoreOrderStatus.paymentPending;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 24),
          Icon(
            paymentPending ? Icons.schedule : Icons.check_circle,
            size: 80,
            color: paymentPending ? colors.tertiary : colors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            paymentPending ? 'Order Created' : 'Order Placed Successfully!',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            paymentPending
                ? 'Your order has been created. Complete payment to confirm it.'
                : 'Your order has been placed. Thank you for shopping with Hindu Pay.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SelectableText(
                    order.id,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(height: 28),
                  Text('Items', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 6),
                  for (final name in order.productNames)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text('• $name'),
                    ),
                  const Divider(height: 28),
                  Text('Deliver to: ${order.addressName}'),
                  const SizedBox(height: 4),
                  Text(order.deliveryAddress),
                  Text(order.phone),
                  const Divider(height: 28),
                  Text('Payment: $_paymentLabel'),
                  const SizedBox(height: 8),
                  Text(
                    'Total: ₹${order.totalAmount.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (paymentPending) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Payment is not verified in this demo.',
                      style: TextStyle(color: colors.error),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go('/store'),
            child: const Text('Continue Shopping'),
          ),
          OutlinedButton(
            onPressed: () => context.go('/store/orders'),
            child: const Text('View My Orders'),
          ),
        ],
      ),
    );
  }
}
