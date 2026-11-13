import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/store_order.dart';
import '../repositories/checkout_repository.dart';

class PlaceOrder {
  final CheckoutRepository repository;

  PlaceOrder(this.repository);

  Future<Either<Failure, StoreOrder>> call({
    required List<String> productNames,
    required String addressName,
    required String deliveryAddress,
    required String phone,
    required double totalAmount,
    required StorePaymentMethod paymentMethod,
  }) {
    return repository.placeOrder(
      productNames: productNames,
      addressName: addressName,
      deliveryAddress: deliveryAddress,
      phone: phone,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
    );
  }
}
