import '../../domain/entities/product_details.dart';

class ProductDetailModel extends ProductDetail {
  const ProductDetailModel({
    required super.id,
    required super.name,
    required super.description,
    required super.images,
    required super.price,
    super.originalPrice,
    super.discountPercentage,
    super.rating,
    super.reviewCount,
    required super.includedItems,
    required super.productInformation,
    required super.deliveryInformation,
    required super.recommendedProducts,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',

      images: (json['images'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),

      price: (json['price'] as num?)?.toDouble() ?? 0,

      originalPrice: (json['original_price'] as num?)?.toDouble(),

      discountPercentage: (json['discount_percentage'] as num?)?.toInt(),

      rating: (json['rating'] as num?)?.toDouble(),

      reviewCount: (json['review_count'] as num?)?.toInt(),

      includedItems: (json['included_items'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                ProductIncludedItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),

      productInformation: ProductInformationModel.fromJson(
        json['product_information'] as Map<String, dynamic>? ?? {},
      ),

      deliveryInformation: DeliveryInformationModel.fromJson(
        json['delivery_information'] as Map<String, dynamic>? ?? {},
      ),

      recommendedProducts:
          (json['recommended_products'] as List<dynamic>? ?? [])
              .map(
                (item) => RecommendedProductModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}

class ProductIncludedItemModel extends ProductIncludedItem {
  const ProductIncludedItemModel({
    required super.id,
    required super.name,
    required super.image,
    required super.quantity,
  });

  factory ProductIncludedItemModel.fromJson(Map<String, dynamic> json) {
    return ProductIncludedItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      quantity: json['quantity']?.toString() ?? '',
    );
  }
}

class ProductInformationModel extends ProductInformation {
  const ProductInformationModel({
    required super.material,
    required super.finish,
    required super.diameter,
    required super.usage,
    required super.weight,
    required super.packaging,
  });

  factory ProductInformationModel.fromJson(Map<String, dynamic> json) {
    return ProductInformationModel(
      material: json['material']?.toString() ?? '',
      finish: json['finish']?.toString() ?? '',
      diameter: json['diameter']?.toString() ?? '',
      usage: json['usage']?.toString() ?? '',
      weight: json['weight']?.toString() ?? '',
      packaging: json['packaging']?.toString() ?? '',
    );
  }
}

class DeliveryInformationModel extends DeliveryInformation {
  const DeliveryInformationModel({
    required super.deliveryText,
    required super.returnText,
    required super.trustedText,
  });

  factory DeliveryInformationModel.fromJson(Map<String, dynamic> json) {
    return DeliveryInformationModel(
      deliveryText: json['delivery_text']?.toString() ?? '',
      returnText: json['return_text']?.toString() ?? '',
      trustedText: json['trusted_text']?.toString() ?? '',
    );
  }
}

class RecommendedProductModel extends StoreProduct {
  const RecommendedProductModel({
    required super.id,
    required super.name,
    required super.image,
    required super.price,
    super.originalPrice,
    super.discountPercentage,
    super.rating,
    super.reviewCount,
  });

  factory RecommendedProductModel.fromJson(Map<String, dynamic> json) {
    return RecommendedProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      discountPercentage: (json['discount_percentage'] as num?)?.toInt(),
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: (json['review_count'] as num?)?.toInt(),
    );
  }
}
