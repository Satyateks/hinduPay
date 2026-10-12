import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class UpdateCartQuantity {
  final CartRepository repository;

  UpdateCartQuantity(this.repository);

  Future<Either<Failure, Cart>> call({
    required String cartItemId,
    required int quantity,
  }) {
    return repository.updateQuantity(
      cartItemId: cartItemId,
      quantity: quantity,
    );
  }
}
