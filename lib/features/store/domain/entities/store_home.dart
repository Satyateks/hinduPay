import 'package:equatable/equatable.dart';

class StoreHome extends Equatable {
  final List<StoreCategory> categories;
  final List<StoreProduct> bestSellingProducts;
  final List<StoreHomeBanner> banners;
  final List<StoreProduct> shopByOccasion;
  final List<StoreProduct> newlyLaunched;
  final List<StoreProduct> bestSellers;
  final List<StoreProduct> murtiAndMala;

  const StoreHome({
    this.categories = const [],
    this.bestSellingProducts = const [],
    this.banners = const [],
    this.shopByOccasion = const [],
    this.newlyLaunched = const [],
    this.bestSellers = const [],
    this.murtiAndMala = const [],
  });

  @override
  List<Object?> get props => [
    categories,
    bestSellingProducts,
    banners,
    shopByOccasion,
    newlyLaunched,
    bestSellers,
    murtiAndMala,
  ];
}

class StoreCategory extends Equatable {
  final String id;
  final String name;
  final String image;

  const StoreCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  @override
  List<Object?> get props => [id, name, image];
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
  final String? category;

  const StoreProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    this.rating,
    this.reviewCount,
    this.category,
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
    category,
  ];
}

class StoreHomeBanner extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String? buttonText;

  const StoreHomeBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    this.buttonText,
  });

  @override
  List<Object?> get props => [id, title, subtitle, image, buttonText];
}
