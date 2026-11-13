import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/product_review.dart';
import '../bloc/reviews/reviews_bloc.dart';
import '../bloc/reviews/reviews_event.dart';
import '../bloc/reviews/reviews_state.dart';

class ProductReviewsPage extends StatelessWidget {
  final String productId;

  const ProductReviewsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReviewsBloc>()..add(LoadProductReviews(productId)),
      child: _ProductReviewsView(productId: productId),
    );
  }
}

class _ProductReviewsView extends StatelessWidget {
  final String productId;

  const _ProductReviewsView({required this.productId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ratings & Reviews')),
      body: BlocConsumer<ReviewsBloc, ReviewsState>(
        listener: (context, state) {
          final message = state.successMessage ?? state.errorMessage;
          if (message != null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          
        },
        builder: (context, state) {
          if (state.status == ReviewsStatus.loading && state.reviews.isEmpty) return const Center(child: CircularProgressIndicator());
          
          if (state.status == ReviewsStatus.failure && state.reviews.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? 'Unable to load reviews.'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: ()=>context.read<ReviewsBloc>().add(LoadProductReviews(productId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Text(
                        state.averageRating.toStringAsFixed(1),
                        style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      _StarRow(rating: state.averageRating.round()),
                      const SizedBox(height: 4),
                      Text('${state.reviews.length} reviews'),
                      const SizedBox(height: 16),
                      for (int rating = 5; rating >= 1; rating--)
                        _RatingBar(
                          rating: rating,
                          count: state.getRatingCount(rating),
                          total: state.reviews.length,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: state.status == ReviewsStatus.submitting
                      ? null
                      : () => _showReviewForm(context, productId),
                  icon: const Icon(Icons.rate_review_outlined),
                  label: const Text('Write a Review'),
                ),
              ),
              const SizedBox(height: 16),
              Text('Customer Reviews', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (state.reviews.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No reviews yet. Be the first to review!')),
                )
              else ...state.reviews.map((review) => _ReviewCard(review: review)),
            ],
          );
        },
      ),
    );
  }

  void _showReviewForm(BuildContext context, String productId) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final commentController = TextEditingController();
    int rating = 5;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Write a Review'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Tap a star to rate this product'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final star = index + 1;

                          return IconButton(
                            onPressed: ()=> setDialogState(() => rating = star),                            icon: Icon(
                              star <= rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 30,
                            ),
                          );
                        }),
                      ),
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Review title',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Enter a title';
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: commentController,
                        minLines: 2,
                        maxLines: 4,
                        decoration: const InputDecoration(labelText: 'Your review'),
                        validator: (value) {
                          if (value == null || value.trim().length < 5) return 'Write at least 5 characters';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    context.read<ReviewsBloc>().add(
                      SubmitReviewEvent(
                        productId: productId,
                        rating: rating,
                        title: titleController.text.trim(),
                        comment: commentController.text.trim(),
                      ),
                    );
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      titleController.dispose();
      commentController.dispose();
    });
  }
}

class _StarRow extends StatelessWidget {
  final int rating;

  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        ),
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final int rating;
  final int count;
  final int total;

  const _RatingBar({
    required this.rating,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : count / total;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 34, child: Text('$rating ★')),
          Expanded(child: LinearProgressIndicator(value: progress)),
          const SizedBox(width: 8),
          SizedBox(width: 26, child: Text('$count', textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ProductReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Text(review.userName.isNotEmpty ? review.userName[0].toUpperCase() : '?')),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.userName,style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      Text('${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                if (review.isVerifiedPurchase)
                  const Chip(
                    avatar: Icon(Icons.verified, size: 16),
                    label: Text('Verified'),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            _StarRow(rating: review.rating),
            const SizedBox(height: 6),
            Text(review.title,style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(review.comment),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => context.read<ReviewsBloc>().add(MarkReviewHelpfulEvent(review.id)),
                icon: const Icon(Icons.thumb_up_outlined, size: 18), label: Text('Helpful (${review.helpfulCount})'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
