import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/review_repository.dart';
import '../../../domain/usecases/get_product_reviews.dart';
import 'reviews_event.dart';
import 'reviews_state.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  final GetProductReviews getProductReviews;
  final SubmitProductReview submitProductReview;
  final MarkReviewHelpful markReviewHelpful;

  ReviewsBloc({
    required this.getProductReviews,
    required this.submitProductReview,
    required this.markReviewHelpful,
  }) : super(const ReviewsState()) {
    on<LoadProductReviews>(_onLoad);
    on<SubmitReviewEvent>(_onSubmit);
    on<MarkReviewHelpfulEvent>(_onHelpful);
  }

  Future<void> _onLoad(
    LoadProductReviews event,
    Emitter<ReviewsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ReviewsStatus.loading,
        productId: event.productId,
        clearError: true,
        clearSuccess: true,
      ),
    );

    final result = await getProductReviews(productId: event.productId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ReviewsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (reviews) => emit(
        state.copyWith(
          status: ReviewsStatus.success,
          reviews: reviews,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onSubmit(
    SubmitReviewEvent event,
    Emitter<ReviewsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ReviewsStatus.submitting,
        clearError: true,
        clearSuccess: true,
      ),
    );

    final result = await submitProductReview(
      productId: event.productId,
      rating: event.rating,
      title: event.title,
      comment: event.comment,
    );

    await result.fold<Future<void>>(
      (failure) async {
        emit(
          state.copyWith(
            status: ReviewsStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (review) async {
        final updatedReviews = [review, ...state.reviews];

        emit(
          state.copyWith(
            status: ReviewsStatus.success,
            reviews: updatedReviews,
            successMessage: 'Review submitted successfully.',
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onHelpful(
    MarkReviewHelpfulEvent event,
    Emitter<ReviewsState> emit,
  ) async {
    final result = await markReviewHelpful(reviewId: event.reviewId);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (updatedReview) {
        final updatedReviews = state.reviews.map((review) {
          return review.id == updatedReview.id ? updatedReview : review;
        }).toList();

        emit(state.copyWith(reviews: updatedReviews, clearError: true));
      },
    );
  }
}
