import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/product_details.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductDetail>> getProductDetails(String productId);
}
