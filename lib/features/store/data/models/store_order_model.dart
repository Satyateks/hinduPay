import '../../domain/entities/store_order.dart';

class StoreOrderModel extends StoreOrder {
  const StoreOrderModel({
    required super.id,
    required super.productNames,
    required super.addressName,
    required super.deliveryAddress,
    required super.phone,
    required super.totalAmount,
    required super.paymentMethod,
    required super.status,
    required super.createdAt,
    required super.trackingStatus,
    required super.estimatedDelivery,
  });

  factory StoreOrderModel.fromJson(Map<String, dynamic> json) {
    return StoreOrderModel(
      id: json['id'] as String,
      productNames: (json['product_names'] as List).map((item) => item.toString()).toList(),
      addressName: json['address_name'] as String,
      deliveryAddress: json['delivery_address'] as String,
      phone: json['phone'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      paymentMethod: StorePaymentMethod.values.firstWhere((method) => method.name == json['payment_method'],orElse: () => StorePaymentMethod.cashOnDelivery),
      status: StoreOrderStatus.values.firstWhere((status) => status.name == json['status'],orElse: () => StoreOrderStatus.placed),
      createdAt: DateTime.parse(json['created_at'] as String), 
      trackingStatus: StoreOrderStatus.values.firstWhere((status) => status.name == json['status'],orElse: () => StoreOrderStatus.placed), estimatedDelivery: null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_names': productNames,
    'address_name': addressName,
    'delivery_address': deliveryAddress,
    'phone': phone,
    'total_amount': totalAmount,
    'payment_method': paymentMethod.name,
    'status': status.name,
    'created_at': createdAt.toIso8601String(),
  };
}
