import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Cart>> getCart() async {
    try {
      return Right(await remoteDataSource.getCart());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> addToCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      return Right(
        await remoteDataSource.addToCart(
          productId: productId,
          quantity: quantity,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> updateQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    try {
      return Right(
        await remoteDataSource.updateQuantity(
          cartItemId: cartItemId,
          quantity: quantity,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> removeFromCart({
    required String cartItemId,
  }) async {
    try {
      return Right(
        await remoteDataSource.removeFromCart(cartItemId: cartItemId),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
