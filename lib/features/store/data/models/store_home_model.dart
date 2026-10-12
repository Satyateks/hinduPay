import '../../domain/entities/store_home.dart';
import 'store_banner_model.dart';
import 'store_category_model.dart';
import 'store_product_model.dart';

class StoreHomeModel extends StoreHome {
  const StoreHomeModel({
    required super.categories,
    required super.bestSellingProducts,
    required super.banners,
    required super.shopByOccasion,
    required super.newlyLaunched,
    required super.bestSellers,
    required super.murtiAndMala,
  });

  factory StoreHomeModel.fromJson(Map<String, dynamic> json) {
    return StoreHomeModel(
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map(
            (item) => StoreCategoryModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),

      bestSellingProducts:
          (json['best_selling_products'] as List<dynamic>? ?? [])
              .map(
                (item) =>
                    StoreProductModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),

      banners: (json['banners'] as List<dynamic>? ?? [])
          .map(
            (item) => StoreBannerModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),

      shopByOccasion: (json['shop_by_occasion'] as List<dynamic>? ?? [])
          .map(
            (item) => StoreProductModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),

      newlyLaunched: (json['newly_launched'] as List<dynamic>? ?? [])
          .map(
            (item) => StoreProductModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),

      bestSellers: (json['best_sellers'] as List<dynamic>? ?? [])
          .map(
            (item) => StoreProductModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),

      murtiAndMala: (json['murti_and_mala'] as List<dynamic>? ?? [])
          .map(
            (item) => StoreProductModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}


