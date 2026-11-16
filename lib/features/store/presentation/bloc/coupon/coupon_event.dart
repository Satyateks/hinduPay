import 'package:equatable/equatable.dart';

abstract class CouponEvent extends Equatable {
  const CouponEvent(); 
  @override
  List<Object?> get props => [];
}

class LoadCoupons extends CouponEvent {
  const LoadCoupons();
}
