import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/store_order.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, StoreOrder>> placeOrder({
    required List<String> productNames,
    required String addressName,
    required String deliveryAddress,
    required String phone,
    required double totalAmount,
    required StorePaymentMethod paymentMethod,
  });
}
