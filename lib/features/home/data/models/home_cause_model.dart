import '../../domain/entities/home_data.dart';

class HomeCauseModel extends HomeCause {
  const HomeCauseModel({
    required super.id,
    required super.title,
    required super.image,
    super.targetAmount,
    super.collectedAmount,
  });

  factory HomeCauseModel.fromJson(Map<String, dynamic> json) {
    return HomeCauseModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      targetAmount: _toDouble(json['target_amount']),
      collectedAmount: _toDouble(json['collected_amount']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }
}