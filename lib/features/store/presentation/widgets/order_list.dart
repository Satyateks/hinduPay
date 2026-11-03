import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../bloc/order/orders_bloc.dart';
import '../bloc/order/orders_event.dart';
import '../bloc/order/orders_state.dart';
import '../../domain/entities/store_order.dart';

class OrderList extends StatelessWidget {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrdersBloc>()..add(const LoadOrders()),
      child: const _OrderListView(),
    );
  }
}

class _OrderListView extends StatelessWidget {
  const _OrderListView();

  String _statusLabel(StoreOrder order) {
    if (order.status == StoreOrderStatus.paymentPending) {
      return 'Payment Pending';
    }

    switch (order.trackingStatus) {
      case StoreOrderStatus.paymentPending:
        return 'Payment Pending';
      case StoreOrderStatus.placed:
        return 'Order Placed';
      case StoreOrderStatus.confirmed:
        return 'Confirmed';
      case StoreOrderStatus.shipped:
        return 'Shipped';
      case StoreOrderStatus.outForDelivery:
        return 'Out for Delivery';
      case StoreOrderStatus.delivered:
        return 'Delivered';
      case StoreOrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state.status == OrdersStatus.loading ||
              state.status == OrdersStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == OrdersStatus.failure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? 'Unable to load orders'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () =>
                        context.read<OrdersBloc>().add(const LoadOrders()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.orders.isEmpty) {
            return const Center(
              child: Text('No orders yet. Your orders will appear here.'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<OrdersBloc>().add(const LoadOrders());
              await Future<void>.delayed(const Duration(milliseconds: 350));
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = state.orders[index];

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      context.pushNamed(
                        'order-details',
                        pathParameters: {'orderId': order.id},
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.receipt_long_outlined),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Order #${order.id}',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(order.productNames.join(', ')),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _statusLabel(order),
                                  style: TextStyle(
                                    color:
                                        order.trackingStatus ==
                                            StoreOrderStatus.delivered
                                        ? Colors.green
                                        : Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                '₹${order.totalAmount.toStringAsFixed(0)}',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Ordered ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
