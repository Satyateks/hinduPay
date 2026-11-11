import '../../domain/entities/product_review.dart';

class ProductReviewModel extends ProductReview {
  const ProductReviewModel({
    required super.id,
    required super.productId,
    required super.userName,
    required super.rating,
    required super.title,
    required super.comment,
    required super.createdAt,
    super.helpfulCount,
    super.isVerifiedPurchase,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      userName: json['user_name'] as String,
      rating: json['rating'] as int,
      title: json['title'] as String,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      helpfulCount: json['helpful_count'] as int? ?? 0,
      isVerifiedPurchase: json['is_verified_purchase'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_name': userName,
      'rating': rating,
      'title': title,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'helpful_count': helpfulCount,
      'is_verified_purchase': isVerifiedPurchase,
    };
  }
}
