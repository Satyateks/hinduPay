import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_order_details.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrders getOrders;
  final GetOrderDetails getOrderDetails;

  OrdersBloc({
    required this.getOrders,
    required this.getOrderDetails,
  }) : super(const OrdersState()) {
    on<LoadOrders>(_loadOrders);
    on<LoadOrderDetails>(_loadOrderDetails);
  }

  Future<void> _loadOrders(
    LoadOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersState(status: OrdersStatus.loading));
    final result = await getOrders();

    result.fold(
      (failure) => emit(OrdersState(status: OrdersStatus.failure,errorMessage: failure.message)),
      (orders) => emit(OrdersState(status: OrdersStatus.success,orders: orders)),
    );
  }

  Future<void> _loadOrderDetails(
    LoadOrderDetails event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersState(status: OrdersStatus.loading));
    final result = await getOrderDetails(event.orderId);

    result.fold(
      (failure) => emit(OrdersState(status: OrdersStatus.failure,errorMessage: failure.message)),
      (order) => emit(OrdersState(status: OrdersStatus.success,selectedOrder: order)),
    );
  }
}