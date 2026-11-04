import 'dart:math';

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/store_order.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_remote_datasource.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;

  CheckoutRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, StoreOrder>> placeOrder({
    required List<String> productNames,
    required String addressName,
    required String deliveryAddress,
    required String phone,
    required double totalAmount,
    required StorePaymentMethod paymentMethod,
  }) async {
    try {
      if (productNames.isEmpty || totalAmount < 0) return Left(ServerFailure(e.toString()));
      

      final order = await remoteDataSource.placeOrder(
        productNames: productNames,
        addressName: addressName,
        deliveryAddress: deliveryAddress,
        phone: phone,
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
      );

      return Right(order);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
