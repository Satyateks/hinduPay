import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/store_order.dart';
import '../bloc/order/orders_bloc.dart';
import '../bloc/order/orders_event.dart';
import '../bloc/order/orders_state.dart';

class OrderDetails extends StatelessWidget {
  final String orderId;

  const OrderDetails({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrdersBloc>()..add(LoadOrderDetails(orderId)),
      child: const _OrderDetailsView(),
    );
  }
}

class _OrderDetailsView extends StatelessWidget {
  const _OrderDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state.status == OrdersStatus.loading ||
              state.status == OrdersStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == OrdersStatus.failure) {
            return Center(
              child: Text(state.errorMessage ?? 'Order not found'),
            );
          }

          final order = state.selectedOrder;
          if (order == null) {
            return const Center(child: Text('Order not found'));
          }

          return _OrderDetailsContent(order: order);
        },
      ),
    );
  }
}

class _OrderDetailsContent extends StatelessWidget {
  final StoreOrder order;

  const _OrderDetailsContent({required this.order});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final paymentPending = order.status == StoreOrderStatus.paymentPending;

    final trackingSteps = <(StoreOrderStatus, String, String)>[
      (
        StoreOrderStatus.placed,
        'Order Placed',
        'We have received your order',
      ),
      (
        StoreOrderStatus.confirmed,
        'Order Confirmed',
        'Your order has been confirmed',
      ),
      (
        StoreOrderStatus.shipped,
        'Shipped',
        'Your order is on its way',
      ),
      (
        StoreOrderStatus.outForDelivery,
        'Out for Delivery',
        'Your order is with the delivery partner',
      ),
      (
        StoreOrderStatus.delivered,
        'Delivered',
        'Your order has been delivered',
      ),
    ];

    final currentIndex = trackingSteps.indexWhere((step) => step.$1 == order.trackingStatus);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order #${order.id}',style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  paymentPending ? 'Payment pending' : order.trackingStatus.name,
                  style: TextStyle(fontWeight: FontWeight.bold,color: paymentPending ? colors.error : colors.primary),
                ),
                if (order.estimatedDelivery != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Estimated delivery: '
                    '${order.estimatedDelivery!.day}/'
                    '${order.estimatedDelivery!.month}/'
                    '${order.estimatedDelivery!.year}',
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('Track Your Order',style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        if (order.trackingStatus == StoreOrderStatus.cancelled)
          const ListTile(
            leading: Icon(Icons.cancel_outlined, color: Colors.red),
            title: Text('Order Cancelled'),
          )
        else
          for (var i = 0; i < trackingSteps.length; i++)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                currentIndex >= i
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: currentIndex >= i ? Colors.green : colors.outline,
              ),
              title: Text(trackingSteps[i].$2),
              subtitle: Text(trackingSteps[i].$3),
            ),
        const SizedBox(height: 16),
        Text('Items',style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              for (final name in order.productNames) ListTile(leading: const Icon(Icons.shopping_bag_outlined),title: Text(name)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Delivery Address',style: Theme.of(context).textTheme.titleMedium),
        Card(
          child: ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(order.addressName),
            subtitle: Text('${order.deliveryAddress}\n${order.phone}'),
            isThreeLine: true,
          ),
        ),
        const SizedBox(height: 16),
        Text('Payment Summary',style: Theme.of(context).textTheme.titleMedium),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Method: ${order.paymentMethod.name}'),
                const SizedBox(height: 8),
                Text(
                  'Total: ₹${order.totalAmount.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (paymentPending)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('Payment has not been verified yet.'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


