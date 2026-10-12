import '../../domain/entities/store_home.dart';

class StoreCategoryModel extends StoreCategory {
  const StoreCategoryModel({
    required super.id,
    required super.name,
    required super.image,
  });

  factory StoreCategoryModel.fromJson(Map<String, dynamic> json) {
    return StoreCategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}
