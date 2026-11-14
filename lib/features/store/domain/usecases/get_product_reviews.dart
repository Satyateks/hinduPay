import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/product_review.dart';
import '../repositories/review_repository.dart';

class GetProductReviews {
  final ReviewRepository repository;
  GetProductReviews(this.repository);

  Future<Either<Failure, List<ProductReview>>> call({required String productId}) {
    return repository.getProductReviews(productId: productId);
  }
}
