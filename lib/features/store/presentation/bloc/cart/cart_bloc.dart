import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/add_to_cart.dart';
import '../../../domain/usecases/get_cart.dart';
import '../../../domain/usecases/remove_from_cart.dart';
import '../../../domain/usecases/update_cart_quantity.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCart getCart;
  final AddToCart addToCart;
  final UpdateCartQuantity updateCartQuantity;
  final RemoveFromCart removeFromCart;

  CartBloc({
    required this.getCart,
    required this.addToCart,
    required this.updateCartQuantity,
    required this.removeFromCart,
  }) : super(const CartState.initial()) {
    on<LoadCart>(_onLoadCart);
    on<RefreshCart>(_onRefreshCart);
    on<AddProductToCart>(_onAddProduct);
    on<ChangeCartQuantity>(_onChangeQuantity);
    on<RemoveCartItem>(_onRemoveItem);
    on<ApplyCartCoupon>(_onApplyCartCoupon);
    on<RemoveCartCoupon>(_onRemoveCartCoupon);
    on<ChangeDeliveryAddress>(_onChangeDeliveryAddress);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(const CartState.loading());

    final result = await getCart();

    result.fold(
      (failure) {
        emit(CartState.failure(failure.message));
      },
      (cart) {
        emit(CartState.success(cart));
      },
    );
  }

  Future<void> _onRefreshCart(
    RefreshCart event,
    Emitter<CartState> emit,
  ) async {
    final result = await getCart();

    result.fold(
      (failure) {
        emit(CartState.failure(failure.message));
      },
      (cart) {
        emit(CartState.success(cart));
      },
    );
  }

  Future<void> _onAddProduct(
    AddProductToCart event,
    Emitter<CartState> emit,
  ) async {
    final result = await addToCart(
      productId: event.productId,
      quantity: event.quantity,
    );

    result.fold(
      (failure) {
        emit(CartState.failure(failure.message));
      },
      (cart) {
        emit(CartState.success(cart));
      },
    );
  }

  Future<void> _onChangeQuantity(
    ChangeCartQuantity event,
    Emitter<CartState> emit,
  ) async {
    final currentCart = state.cart;

    if (currentCart != null) {
      emit(CartState.updating(currentCart));
    }

    if (event.quantity <= 0) {
      add(RemoveCartItem(cartItemId: event.cartItemId));
      return;
    }

    final result = await updateCartQuantity(
      cartItemId: event.cartItemId,
      quantity: event.quantity,
    );

    result.fold(
      (failure) {
        emit(CartState.failure(failure.message));
      },
      (cart) {
        emit(CartState.success(cart));
      },
    );
  }

  Future<void> _onRemoveItem(
    RemoveCartItem event,
    Emitter<CartState> emit,
  ) async {
    final currentCart = state.cart;

    if (currentCart != null) {
      emit(CartState.updating(currentCart));
    }

    final result = await removeFromCart(cartItemId: event.cartItemId);

    result.fold(
      (failure) {
        emit(CartState.failure(failure.message));
      },
      (cart) {
        emit(CartState.success(cart));
      },
    );
  }
  void _onChangeDeliveryAddress(
    ChangeDeliveryAddress event,
    Emitter<CartState> emit,
  ) {
    final currentCart = state.cart;

    if (currentCart == null) return;

    emit(
      CartState.success(
        currentCart.copyWith(
          deliveryAddress: event.address,
        ),
      ),
    );
  }

  void _onApplyCartCoupon(ApplyCartCoupon event, Emitter<CartState> emit) {
    final cart = state.cart;
    if (cart == null) return;

    final availableAmount =(cart.subtotal - cart.discount).clamp(0.0, double.infinity);
    final couponDiscount =event.couponDiscount.clamp(0.0, availableAmount).toDouble();
    final total = (availableAmount - couponDiscount + cart.deliveryCharge).clamp(0.0, double.infinity).toDouble();
    // final couponDiscount = event.couponDiscount.clamp(0.0, (cart.subtotal - cart.discount).clamp(0.0, double.infinity)).toDouble();
    // final total =(cart.subtotal - cart.discount - couponDiscount + cart.deliveryCharge).clamp(0.0, double.infinity).toDouble();
    emit(CartState.success(cart.copyWith(appliedCouponCode: event.couponCode,couponDiscount: couponDiscount,total: total)));
  }

  void _onRemoveCartCoupon(RemoveCartCoupon event, Emitter<CartState> emit) {
    final cart = state.cart;
    if (cart == null) return;
    final total = (cart.subtotal - cart.discount + cart.deliveryCharge).clamp(0.0, double.infinity).toDouble();
    emit(CartState.success(cart.copyWith(clearCoupon: true, couponDiscount: 0, total: total)));
  }
 
}

