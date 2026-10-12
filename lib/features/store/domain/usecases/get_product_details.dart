import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/product_details.dart';
import '../repositories/product_repository.dart';

class GetProductDetails {
  final ProductRepository repository;

  GetProductDetails(this.repository);

  Future<Either<Failure, ProductDetail>> call(String productId) {
    return repository.getProductDetails(productId);
  }
}
