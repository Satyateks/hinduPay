import 'package:equatable/equatable.dart';

import '../../../domain/entities/store_order.dart';

enum OrdersStatus { initial, loading, success, failure }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<StoreOrder> orders;
  final StoreOrder? selectedOrder;
  final String? errorMessage;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.selectedOrder,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, orders, selectedOrder, errorMessage];
}
