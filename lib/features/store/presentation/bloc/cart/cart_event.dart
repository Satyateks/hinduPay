import 'package:equatable/equatable.dart';

import '../../../domain/entities/cart.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class RefreshCart extends CartEvent {
  const RefreshCart();
}

class AddProductToCart extends CartEvent {
  final String productId;
  final int quantity;

  const AddProductToCart({required this.productId, this.quantity = 1});
  @override
  List<Object?> get props => [productId, quantity];
}

class ChangeCartQuantity extends CartEvent {
  final String cartItemId;
  final int quantity;

  const ChangeCartQuantity({required this.cartItemId, required this.quantity});
  @override
  List<Object?> get props => [cartItemId, quantity];
}

class RemoveCartItem extends CartEvent {
  final String cartItemId;

  const RemoveCartItem({required this.cartItemId});

  @override
  List<Object?> get props => [cartItemId];
}

class ChangeDeliveryAddress extends CartEvent {
  final CartAddress address;
  const ChangeDeliveryAddress({
    required this.address,
  });

  @override
  List<Object?> get props => [address];
}



