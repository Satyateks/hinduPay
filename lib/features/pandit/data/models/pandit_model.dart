import '../../domain/entities/pandit.dart';

class PanditModel extends Pandit {
  const PanditModel({
    required super.id,
    required super.name,
    required super.specialization,
    required super.imageUrl,
    required super.rating,
    required super.supportedPoojas,
  });

  factory PanditModel.fromJson(Map<String, dynamic> json) {
    return PanditModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      imageUrl: json['image_url'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      supportedPoojas: List<String>.from(json['supported_poojas'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'image_url': imageUrl,
      'rating': rating,
      'supported_poojas': supportedPoojas,
    };
  }
}
