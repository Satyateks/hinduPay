import '../../domain/entities/pandit.dart';

class PanditModel extends Pandit {
  const PanditModel({
    required super.id,
    required super.name,
    required super.specialization,
    required super.imageUrl,
    required super.rating,
    required super.location,
    required super.supportedPoojas,
  });

  factory PanditModel.fromJson(Map<String, dynamic> json) {
    final rawPoojas =
        json['supported_poojas'] ?? json['supportedPoojas'] ?? json['supportedpoojas'] ?? [];
    return PanditModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      specialization: json['specialization']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      rating: (json['rating'] as num? ?? 0.0).toDouble(),
      supportedPoojas: List<String>.from(rawPoojas),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'image_url': imageUrl,
      'rating': rating,
      'location': location,
      'supported_poojas': supportedPoojas,
    };
  }
}

class PanditPoojaServiceModel extends PanditPoojaService {
  const PanditPoojaServiceModel({
    required super.id,
    required super.title,
    required super.category,
    required super.panditId,
    required super.panditName,
    required super.price,
    required super.originalPrice,
    required super.rating,
    required super.reviewCountLabel,
    required super.visualKind,
    required super.duration,
    required super.description,
  });

  factory PanditPoojaServiceModel.fromJson(Map<String, dynamic> json) {
    return PanditPoojaServiceModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      panditId: json['pandit_id']?.toString() ?? '',
      panditName: json['pandit_name']?.toString() ?? '',
      price: (json['price'] as num? ?? 0).toInt(),
      originalPrice: (json['original_price'] as num? ?? 0).toInt(),
      rating: (json['rating'] as num? ?? 4.7).toDouble(),
      reviewCountLabel: json['review_count_label']?.toString() ?? '10k+',
      visualKind: json['visual_kind']?.toString() ?? 'vedic_pooja',
      duration: json['duration']?.toString() ?? '90 mins',
      description: json['description']?.toString() ?? '',
    );
  }
}

class SamagriItemModel extends SamagriItem {
  const SamagriItemModel({
    required super.id,
    required super.title,
    required super.variant,
    required super.price,
    required super.originalPrice,
    required super.rating,
    required super.reviewCountLabel,
    required super.visualKind,
    super.isFavorite,
  });

  factory SamagriItemModel.fromJson(
    Map<String, dynamic> json, {
    bool isFavorite = false,
  }) {
    return SamagriItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      variant: json['variant']?.toString() ?? 'Medium',
      price: (json['price'] as num? ?? 0).toInt(),
      originalPrice: (json['original_price'] as num? ?? 0).toInt(),
      rating: (json['rating'] as num? ?? 4.9).toDouble(),
      reviewCountLabel: json['review_count_label']?.toString() ?? '16k+',
      visualKind: json['visual_kind']?.toString() ?? 'pooja_thali',
      isFavorite: isFavorite,
    );
  }
}
