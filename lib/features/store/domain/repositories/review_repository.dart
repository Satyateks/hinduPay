import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/product_review.dart';

abstract class ReviewRepository {
  Future<Either<Failure, List<ProductReview>>> getProductReviews({
    required String productId,
  });

  Future<Either<Failure, ProductReview>> submitReview({
    required String productId,
    required int rating,
    required String title,
    required String comment,
  });

  Future<Either<Failure, ProductReview>> markHelpful({required String reviewId});
}

class SubmitProductReview {
  final ReviewRepository repository;

  SubmitProductReview(this.repository);

  Future<Either<Failure, ProductReview>> call({
    required String productId,
    required int rating,
    required String title,
    required String comment,
  }) {
    return repository.submitReview(
      productId: productId,
      rating: rating,
      title: title,
      comment: comment,
    );
  }
}

class MarkReviewHelpful {
  final ReviewRepository repository;

  MarkReviewHelpful(this.repository);

  Future<Either<Failure, ProductReview>> call({required String reviewId}) {
    return repository.markHelpful(reviewId: reviewId);
  }
}
