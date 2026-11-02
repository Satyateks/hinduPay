import 'package:equatable/equatable.dart';

enum CouponType { percentage, flat }

class Coupon extends Equatable {
  final String id;
  final String code;
  final String title;
  final String description;
  final CouponType type;
  final double value;
  final double minOrderValue;
  final double maxDiscount;
  final bool isActive;

  const Coupon({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.type,
    required this.value,
    required this.minOrderValue,
    this.maxDiscount = 0,
    this.isActive = true,
  });

  double calculateDiscount(double orderAmount) {
    if (!isActive || orderAmount < minOrderValue) return 0;

    if (type == CouponType.flat) {
      return value.clamp(0, orderAmount).toDouble();
    }

    final discount = orderAmount * value / 100;
    final cappedDiscount = maxDiscount > 0 ? discount.clamp(0, maxDiscount) : discount;

    return cappedDiscount.clamp(0, orderAmount).toDouble();
  }

  @override
  List<Object?> get props => [
    id,
    code,
    title,
    description,
    type,
    value,
    minOrderValue,
    maxDiscount,
    isActive,
  ];
}

class CouponApplication extends Equatable {
  final Coupon coupon;
  final double discount;

  const CouponApplication({required this.coupon, required this.discount});

  @override
  List<Object?> get props => [coupon, discount];
}
