import '../../domain/entities/home_data.dart';

class HomePoojaModel extends HomePooja {
  const HomePoojaModel({
    required super.id,
    required super.name,
    required super.image,
    required super.price,
  });

  factory HomePoojaModel.fromJson(Map<String, dynamic> json) {
    return HomePoojaModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      price: _toDouble(json['price']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}