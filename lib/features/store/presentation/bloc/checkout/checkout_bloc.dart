import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/place_order.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final PlaceOrder placeOrder;

  CheckoutBloc({required this.placeOrder})
      : super(const CheckoutState()) {
    on<PlaceStoreOrder>(_onPlaceOrder);
  }

  Future<void> _onPlaceOrder(
    PlaceStoreOrder event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutState(status: CheckoutStatus.submitting));

    final result = await placeOrder(
      productNames: event.productNames,
      addressName: event.addressName,
      deliveryAddress: event.deliveryAddress,
      phone: event.phone,
      totalAmount: event.totalAmount,
      paymentMethod: event.paymentMethod,
    );

    result.fold(
      (failure) {
        emit(
          CheckoutState(
            status: CheckoutStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (order) {
        emit(
          CheckoutState(
            status: CheckoutStatus.success,
            order: order,
          ),
        );
      },
    );
  }
}