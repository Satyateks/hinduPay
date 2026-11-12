import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/store_home.dart';
import '../entities/store_order.dart';

abstract class StoreRepository {
  Future<Either<Failure, StoreHome>> getStoreHome();
}

abstract class OrderRepository {
  Future<Either<Failure, List<StoreOrder>>> getOrders();
  Future<Either<Failure, StoreOrder>> getOrderDetails(String orderId);
}