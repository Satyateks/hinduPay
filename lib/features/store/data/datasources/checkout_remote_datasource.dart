import '../models/store_order_model.dart';
import '../../domain/entities/store_order.dart';

abstract class CheckoutRemoteDataSource {
  Future<StoreOrderModel> placeOrder({
    required List<String> productNames,
    required String addressName,
    required String deliveryAddress,
    required String phone,
    required double totalAmount,
    required StorePaymentMethod paymentMethod,
  });
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  @override
  Future<StoreOrderModel> placeOrder({
    required List<String> productNames,
    required String addressName,
    required String deliveryAddress,
    required String phone,
    required double totalAmount,
    required StorePaymentMethod paymentMethod,
  }) async {
    // Dummy API response. Replace with your ApiClient request later.
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final orderId = 'HP${now.millisecondsSinceEpoch}';

    return StoreOrderModel(
      id: orderId,
      productNames: productNames,
      addressName: addressName,
      deliveryAddress: deliveryAddress,
      phone: phone,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      status: paymentMethod == StorePaymentMethod.cashOnDelivery ? StoreOrderStatus.placed : StoreOrderStatus.paymentPending,
      createdAt: now, trackingStatus: paymentMethod == StorePaymentMethod.cashOnDelivery ? StoreOrderStatus.placed : StoreOrderStatus.paymentPending,
      estimatedDelivery: null,
    );
  }
}
