import 'package:equatable/equatable.dart';

class WishlistItem extends Equatable {
  final String id;
  final String productId;
  final String name;
  final String image;
  final double price;
  final double? originalPrice;
  final String category;
  final bool inStock;

  const WishlistItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    this.originalPrice,
    required this.category,
    this.inStock = true,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    name,
    image,
    price,
    originalPrice,
    category,
    inStock,
  ];
}
