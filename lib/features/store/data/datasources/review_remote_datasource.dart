import '../models/product_review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<List<ProductReviewModel>> getProductReviews(String productId);

  Future<ProductReviewModel> submitReview({
    required String productId,
    required int rating,
    required String title,
    required String comment,
  });

  Future<ProductReviewModel> markHelpful(String reviewId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final Map<String, List<ProductReviewModel>> _reviews = {
    '1': [
      ProductReviewModel(
        id: 'review_1',
        productId: '1',
        userName: 'Rahul S.',
        rating: 5,
        title: 'Excellent quality',
        comment: 'Product quality is good and packaging was nice.',
        createdAt: DateTime(2026, 9, 20),
        helpfulCount: 12,
        isVerifiedPurchase: true,
      ),
      ProductReviewModel(
        id: 'review_2',
        productId: '1',
        userName: 'Priya K.',
        rating: 4,
        title: 'Good product',
        comment: 'Looks good and works as expected.',
        createdAt: DateTime(2026, 9, 15),
        helpfulCount: 5,
        isVerifiedPurchase: true,
      ),
      ProductReviewModel(
        id: 'review_3',
        productId: '1',
        userName: 'Amit M.',
        rating: 3,
        title: 'Average',
        comment: 'Product is okay for the price.',
        createdAt: DateTime(2026, 9, 10),
        helpfulCount: 2,
      ),
    ],
    '2': [
      ProductReviewModel(
        id: 'review_1',
        productId: '1',
        userName: 'Rahul S.',
        rating: 5,
        title: 'Excellent quality',
        comment: 'Product quality is good and packaging was nice.',
        createdAt: DateTime(2026, 9, 20),
        helpfulCount: 12,
        isVerifiedPurchase: true,
      ),
      ProductReviewModel(
        id: 'review_2',
        productId: '1',
        userName: 'Priya K.',
        rating: 4,
        title: 'Good product',
        comment: 'Looks good and works as expected.',
        createdAt: DateTime(2026, 9, 15),
        helpfulCount: 5,
        isVerifiedPurchase: true,
      ),
      ProductReviewModel(
        id: 'review_3',
        productId: '1',
        userName: 'Amit M.',
        rating: 3,
        title: 'Average',
        comment: 'Product is okay for the price.',
        createdAt: DateTime(2026, 9, 10),
        helpfulCount: 2,
      ),
    ],
  };

  @override
  Future<List<ProductReviewModel>> getProductReviews(String productId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List<ProductReviewModel>.from(_reviews[productId] ?? []);
  }

  @override
  Future<ProductReviewModel> submitReview({
    required String productId,
    required int rating, required String title,
    required String comment,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (rating < 1 || rating > 5) throw ArgumentError('Rating must be between 1 and 5.');

    final review = ProductReviewModel(
      id: 'review_${DateTime.now().microsecondsSinceEpoch}',
      productId: productId,
      userName: 'You',
      rating: rating,
      title: title,comment: comment,
      createdAt: DateTime.now(),
      isVerifiedPurchase: false,
    );

    _reviews.putIfAbsent(productId, () => []);
    _reviews[productId]!.insert(0, review);

    return review;
  }

  @override
  Future<ProductReviewModel> markHelpful(String reviewId) async {
    for (final entry in _reviews.entries) {
      final index = entry.value.indexWhere((review) => review.id == reviewId);

      if (index != -1) {
        final oldReview = entry.value[index];

        final updatedReview = ProductReviewModel(
          id: oldReview.id,
          productId: oldReview.productId,
          userName: oldReview.userName,
          rating: oldReview.rating,
          title: oldReview.title,
          comment: oldReview.comment,
          createdAt: oldReview.createdAt,
          helpfulCount: oldReview.helpfulCount + 1,
          isVerifiedPurchase: oldReview.isVerifiedPurchase,
        );

        entry.value[index] = updatedReview;
        return updatedReview;
      }
    }
    throw Exception('Review not found.');
  }
}
