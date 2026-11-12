import 'package:equatable/equatable.dart';

class ProductReview extends Equatable {
  final String id;
  final String productId;
  final String userName;
  final int rating;
  final String title;
  final String comment;
  final DateTime createdAt;
  final int helpfulCount;
  final bool isVerifiedPurchase;

  const ProductReview({
    required this.id,
    required this.productId,
    required this.userName,
    required this.rating,
    required this.title,
    required this.comment,
    required this.createdAt,
    this.helpfulCount = 0,
    this.isVerifiedPurchase = false,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    userName,
    rating,
    title,
    comment,
    createdAt,
    helpfulCount,
    isVerifiedPurchase,
  ];
}
