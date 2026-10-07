import '../../domain/entities/home_data.dart';

class HomeAstrologyModel extends HomeAstrology {
  const HomeAstrologyModel({
    required super.title,
    required super.subtitle,
    required super.image,
  });

  factory HomeAstrologyModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return HomeAstrologyModel(
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}

class HomeActivityModel extends HomeActivity {
  const HomeActivityModel({
    required super.id,
    required super.title,
    required super.date,
    required super.image,
  });

  factory HomeActivityModel.fromJson(Map<String, dynamic> json) {
    return HomeActivityModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}

class HomeRecommendationModel extends HomeRecommendation {
  const HomeRecommendationModel({
    required super.id,
    required super.title,
    required super.image,
    required super.type,
  });

  factory HomeRecommendationModel.fromJson(Map<String, dynamic> json) {
    return HomeRecommendationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }
}
