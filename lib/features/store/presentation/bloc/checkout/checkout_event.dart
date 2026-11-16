import 'package:equatable/equatable.dart';

import '../../../domain/entities/store_order.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class PlaceStoreOrder extends CheckoutEvent {
  final List<String> productNames;
  final String addressName;
  final String deliveryAddress;
  final String phone;
  final double totalAmount;
  final StorePaymentMethod paymentMethod;

  const PlaceStoreOrder({
    required this.productNames,
    required this.addressName,
    required this.deliveryAddress,
    required this.phone,
    required this.totalAmount,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [
    productNames,
    addressName,
    deliveryAddress,
    phone,
    totalAmount,
    paymentMethod,
  ];
}
