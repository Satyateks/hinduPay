import 'package:equatable/equatable.dart';

abstract class ReviewsEvent extends Equatable {
  const ReviewsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductReviews extends ReviewsEvent {
  final String productId;

  const LoadProductReviews(this.productId);

  @override
  List<Object?> get props => [productId];
}

class SubmitReviewEvent extends ReviewsEvent {
  final String productId;
  final int rating;
  final String title;
  final String comment;

  const SubmitReviewEvent({
    required this.productId,
    required this.rating,
    required this.title,
    required this.comment,
  });

  @override
  List<Object?> get props => [productId, rating, title, comment];
}

class MarkReviewHelpfulEvent extends ReviewsEvent {
  final String reviewId;

  const MarkReviewHelpfulEvent(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}
