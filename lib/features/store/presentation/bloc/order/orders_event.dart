import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();
  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrdersEvent {
  const LoadOrders();
}

class LoadOrderDetails extends OrdersEvent {
  final String orderId;
  const LoadOrderDetails(this.orderId);
  @override
  List<Object?> get props => [orderId];
}
