import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  Future<Either<Failure, Cart>> call({
    required String productId,
    required int quantity,
  }) {
    return repository.addToCart(productId: productId, quantity: quantity);
  }
}
