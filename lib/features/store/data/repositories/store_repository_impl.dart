import 'dart:math';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/store_home.dart';
import '../../domain/entities/store_order.dart';
import '../../domain/repositories/store_repository.dart';
import '../datasources/store_remote_datasource.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreRemoteDataSource remoteDataSource;

  StoreRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, StoreHome>> getStoreHome() async {
    try {
      final result = await remoteDataSource.getStoreHome();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<StoreOrder>>> getOrders() async {
    try {
      return Right(await remoteDataSource.getOrders());
    } catch (_) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StoreOrder>> getOrderDetails(String orderId) async {
    try {
      final order = await remoteDataSource.getOrderDetails(orderId);

      if (order == null) {
        return Left(ServerFailure(e.toString()));
      }

      return Right(order);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}


