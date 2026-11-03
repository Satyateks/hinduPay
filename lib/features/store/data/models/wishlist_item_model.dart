import '../../domain/entities/wishlist_item.dart';

class WishlistItemModel extends WishlistItem {
  const WishlistItemModel({
    required super.id,
    required super.productId,
    required super.name,
    required super.image,
    required super.price,
    super.originalPrice,
    required super.category,
    super.inStock = true,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['id'].toString(),
      productId: json['product_id'].toString(),
      name: json['name'] as String,
      image: json['image'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      category: json['category'] as String? ?? 'Pooja Essentials',
      inStock: json['in_stock'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_id': productId,
    'name': name,
    'image': image,
    'price': price,
    'original_price': originalPrice,
    'category': category,
    'in_stock': inStock,
  };
}
