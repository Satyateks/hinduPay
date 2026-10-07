import '../../domain/entities/home_data.dart';

class HomeTempleModel extends HomeTemple {
  const HomeTempleModel({
    required super.id,
    required super.name,
    required super.image,
    required super.location,
  });

  factory HomeTempleModel.fromJson(Map<String, dynamic> json) {
    return HomeTempleModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
    );
  }
}
