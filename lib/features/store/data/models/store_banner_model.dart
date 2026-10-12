import '../../domain/entities/store_home.dart';

class StoreBannerModel extends StoreHomeBanner {
  const StoreBannerModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.image,
    super.buttonText,
  });

  factory StoreBannerModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StoreBannerModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      buttonText: json['button_text']?.toString(),
    );
  }
}