import '../../domain/entities/home_data.dart';

class HomeQuickActionModel extends HomeQuickAction {
  const HomeQuickActionModel({
    required super.id,
    required super.title,
    required super.icon,
  });

  factory HomeQuickActionModel.fromJson(Map<String, dynamic> json) {
    return HomeQuickActionModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
    );
  }
}