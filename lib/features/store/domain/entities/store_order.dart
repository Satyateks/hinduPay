import 'package:equatable/equatable.dart';

enum StorePaymentMethod { upi, card, cashOnDelivery }
enum StoreOrderStatus {
  paymentPending,
  placed,
  confirmed,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
}

class StoreOrder extends Equatable {
  final String id;
  final List<String> productNames;
  final String addressName;
  final String deliveryAddress;
  final String phone;
  final double totalAmount;
  final StorePaymentMethod paymentMethod;
  final StoreOrderStatus status;
  final DateTime createdAt;
  final StoreOrderStatus trackingStatus;
  final DateTime? estimatedDelivery;

  const StoreOrder({
    required this.id,
    required this.productNames,
    required this.addressName,
    required this.deliveryAddress,
    required this.phone,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.trackingStatus = StoreOrderStatus.placed,
    required this.estimatedDelivery,
  });

  @override
  List<Object?> get props => [
    id,
    productNames,
    addressName,
    deliveryAddress,
    phone,
    totalAmount,
    paymentMethod,
    status,
    createdAt,
    trackingStatus,
    estimatedDelivery,
  ];
}
