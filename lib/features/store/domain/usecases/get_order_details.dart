import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/store_order.dart';
import '../repositories/store_repository.dart';

class GetOrderDetails {
  final OrderRepository repository;
  GetOrderDetails(this.repository);
  Future<Either<Failure, StoreOrder>> call(String orderId) {return repository.getOrderDetails(orderId);}
}


class GetOrders {
  final OrderRepository repository;
  GetOrders(this.repository);
  Future<Either<Failure, List<StoreOrder>>> call() {return repository.getOrders();}
}