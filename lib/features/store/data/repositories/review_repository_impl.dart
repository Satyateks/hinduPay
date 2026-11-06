import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/product_review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_datasource.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductReview>>> getProductReviews({
    required String productId,
  }) async {
    try {
      final reviews = await remoteDataSource.getProductReviews(productId);
      return Right(reviews);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductReview>> submitReview({
    required String productId,
    required int rating,
    required String title,
    required String comment,
  }) async {
    try {
      final review = await remoteDataSource.submitReview(
        productId: productId,
        rating: rating,
        title: title,
        comment: comment,
      );
      return Right(review);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductReview>> markHelpful({
    required String reviewId,
  }) async {
    try {
      final review = await remoteDataSource.markHelpful(reviewId);
      return Right(review);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
