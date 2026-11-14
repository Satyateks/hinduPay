import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/coupon.dart';
import '../repositories/coupon_repository.dart';

class GetCoupons {
  final CouponRepository repository;
  GetCoupons(this.repository);
  Future<Either<Failure, List<Coupon>>> call() {return repository.getCoupons();}
}
