import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/coupon.dart';

abstract class CouponRepository {
  Future<Either<Failure, List<Coupon>>> getCoupons();
}
