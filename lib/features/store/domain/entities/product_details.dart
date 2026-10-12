import 'package:equatable/equatable.dart';

class ProductDetail extends Equatable {
  final String id;
  final String name;
  final String description;

  final List<String> images;

  final double price;
  final double? originalPrice;
  final int? discountPercentage;

  final double? rating;
  final int? reviewCount;

  final List<ProductIncludedItem> includedItems;

  final ProductInformation productInformation;

  final DeliveryInformation deliveryInformation;

  final List<StoreProduct> recommendedProducts;

  const ProductDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    this.rating,
    this.reviewCount,
    this.includedItems = const [],
    required this.productInformation,
    required this.deliveryInformation,
    this.recommendedProducts = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    images,
    price,
    originalPrice,
    discountPercentage,
    rating,
    reviewCount,
    includedItems,
    productInformation,
    deliveryInformation,
    recommendedProducts,
  ];
}

class ProductIncludedItem extends Equatable {
  final String id;
  final String name;
  final String image;
  final String quantity;

  const ProductIncludedItem({
    required this.id,
    required this.name,
    required this.image,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, name, image, quantity];
}

class ProductInformation extends Equatable {
  final String material;
  final String finish;
  final String diameter;
  final String usage;
  final String weight;
  final String packaging;

  const ProductInformation({
    required this.material,
    required this.finish,
    required this.diameter,
    required this.usage,
    required this.weight,
    required this.packaging,
  });

  @override
  List<Object?> get props => [
    material,
    finish,
    diameter,
    usage,
    weight,
    packaging,
  ];
}

class DeliveryInformation extends Equatable {
  final String deliveryText;
  final String returnText;
  final String trustedText;

  const DeliveryInformation({
    required this.deliveryText,
    required this.returnText,
    required this.trustedText,
  });

  @override
  List<Object?> get props => [deliveryText, returnText, trustedText];
}

class StoreProduct extends Equatable {
  final String id;
  final String name;
  final String image;
  final double price;
  final double? originalPrice;
  final int? discountPercentage;
  final double? rating;
  final int? reviewCount;

  const StoreProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    this.rating,
    this.reviewCount,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    price,
    originalPrice,
    discountPercentage,
    rating,
    reviewCount,
  ];
}
