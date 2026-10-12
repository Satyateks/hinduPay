import 'package:equatable/equatable.dart';

import '../../../domain/entities/cart.dart';

enum CartStatus { initial, loading, success, updating, failure }

class CartState extends Equatable {
  final CartStatus status;
  final Cart? cart;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,
  });

  const CartState.initial()
    : status = CartStatus.initial,
      cart = null,
      errorMessage = null;

  const CartState.loading()
    : status = CartStatus.loading,
      cart = null,
      errorMessage = null;

  const CartState.success(Cart data)
    : status = CartStatus.success,
      cart = data,
      errorMessage = null;

  const CartState.updating(Cart data)
    : status = CartStatus.updating,
      cart = data,
      errorMessage = null;

  const CartState.failure(String message)
    : status = CartStatus.failure,
      cart = null,
      errorMessage = message;

  @override
  List<Object?> get props => [status, cart, errorMessage];
}
