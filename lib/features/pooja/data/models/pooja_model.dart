import '../../domain/entities/pooja.dart';

class PoojaModel extends Pooja {
  const PoojaModel({
    required super.id,
    required super.name,
    required super.description,
    required super.image,
    required super.price,
    required super.duration,
    required super.category,
    required super.isPopular,
  });

  factory PoojaModel.fromJson(Map<String, dynamic> json) {
    return PoojaModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      duration: json['duration'] ?? '',
      category: json['category'] ?? '',
      isPopular: json['isPopular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'duration': duration,
      'category': category,
      'isPopular': isPopular,
    };
  }
}