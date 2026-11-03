import '../../domain/entities/store_order.dart';

abstract class OrderRemoteDataSource {
  Future<List<StoreOrder>> getOrders();
  Future<StoreOrder?> getOrderDetails(String orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  // In-memory demo data; app restart par reset ho jayega.
  final List<StoreOrder> _orders = [
    StoreOrder(
      id: 'HP10001',
      productNames: const ['Puja Thali Set', 'Brass Ghanti'],
      addressName: 'Rahul Sharma',
      deliveryAddress: 'Techzone 4, Greater Noida, UP - 201310',
      phone: '98XXXXXX10',
      totalAmount: 748,
      paymentMethod: StorePaymentMethod.cashOnDelivery,
      status: StoreOrderStatus.placed,
      trackingStatus: StoreOrderStatus.shipped,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      estimatedDelivery: DateTime.now().add(const Duration(days: 2)),
    ),
    StoreOrder(
      id: 'HP10002',
      productNames: const ['Brass Diya Set'],
      addressName: 'Rahul Sharma',
      deliveryAddress: 'Sector 18, Noida, UP - 201301',
      phone: '98XXXXXX10',
      totalAmount: 399,
      paymentMethod: StorePaymentMethod.upi,
      status: StoreOrderStatus.paymentPending,
      trackingStatus: StoreOrderStatus.paymentPending,
      estimatedDelivery: DateTime.now().add(const Duration(days: 4)),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    StoreOrder(
      id: 'HP10003',
      productNames: const ['Cotton Pooja Wicks'],
      addressName: 'Rahul Sharma',
      deliveryAddress: 'Techzone 4, Greater Noida, UP - 201310',
      phone: '98XXXXXX10',
      totalAmount: 149,
      paymentMethod: StorePaymentMethod.cashOnDelivery,
      status: StoreOrderStatus.placed,
      trackingStatus: StoreOrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      estimatedDelivery: DateTime.now().add(const Duration(days: 5)),
    ),
  ];

  @override
  Future<List<StoreOrder>> getOrders() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_orders);
  }

  @override
  Future<StoreOrder?> getOrderDetails(String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    for (final order in _orders) {if (order.id == orderId) return order;}
    return null;
  }
}
