import '../../domain/entities/coupon.dart';

class CouponModel extends Coupon {
  const CouponModel({
    required super.id,
    required super.code,
    required super.title,
    required super.description,
    required super.type,
    required super.value,
    required super.minOrderValue,
    super.maxDiscount = 0,
    super.isActive = true,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] == 'flat' ? CouponType.flat : CouponType.percentage,
      value: (json['value'] as num).toDouble(),
      minOrderValue: (json['min_order_value'] as num).toDouble(),
      maxDiscount: (json['max_discount'] as num?)?.toDouble() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'title': title,
    'description': description,
    'type': type == CouponType.flat ? 'flat' : 'percentage',
    'value': value,
    'min_order_value': minOrderValue,
    'max_discount': maxDiscount,
    'is_active': isActive,
  };
}
