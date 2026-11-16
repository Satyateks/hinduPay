import 'package:equatable/equatable.dart';

import '../../../domain/entities/coupon.dart';

enum CouponStatus { initial, loading, success, failure }

class CouponState extends Equatable {
  final CouponStatus status;final List<Coupon> coupons;final String? errorMessage;
  const CouponState({this.status = CouponStatus.initial,this.coupons = const [],this.errorMessage});

  CouponState copyWith({
    CouponStatus? status,List<Coupon>? coupons,String? errorMessage}) {
    return CouponState(status: status ?? this.status,coupons: coupons ?? this.coupons,errorMessage: errorMessage);
  }

  @override
  List<Object?> get props => [status, coupons, errorMessage];
}
