import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cart.dart';

abstract class CartRepository {
  Future<Either<Failure, Cart>> getCart();

  Future<Either<Failure, Cart>> addToCart({
    required String productId,
    required int quantity,
  });

  Future<Either<Failure, Cart>> updateQuantity({
    required String cartItemId,
    required int quantity,
  });

  Future<Either<Failure, Cart>> removeFromCart({required String cartItemId});
}
