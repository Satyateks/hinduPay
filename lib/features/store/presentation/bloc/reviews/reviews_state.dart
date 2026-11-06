import 'package:equatable/equatable.dart';

import '../../../domain/entities/product_review.dart';

enum ReviewsStatus { initial, loading, success, submitting, failure }

class ReviewsState extends Equatable {
  final ReviewsStatus status;
  final String productId;
  final List<ProductReview> reviews;
  final String? errorMessage;
  final String? successMessage;

  const ReviewsState({
    this.status = ReviewsStatus.initial,
    this.productId = '',
    this.reviews = const [],
    this.errorMessage,
    this.successMessage,
  });

  double get averageRating {
    if (reviews.isEmpty) return 0;

    final total = reviews.fold<int>(0, (sum, review) => sum + review.rating);

    return total / reviews.length;
  }

  int getRatingCount(int rating) {
    return reviews.where((review) => review.rating == rating).length;
  }

  ReviewsState copyWith({
    ReviewsStatus? status,
    String? productId,
    List<ProductReview>? reviews,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ReviewsState(
      status: status ?? this.status,
      productId: productId ?? this.productId,
      reviews: reviews ?? this.reviews,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    productId,
    reviews,
    errorMessage,
    successMessage,
  ];
}
