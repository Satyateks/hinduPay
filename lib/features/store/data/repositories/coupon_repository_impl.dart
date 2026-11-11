import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/coupon.dart';
import '../../domain/repositories/coupon_repository.dart';
import '../datasources/coupon_remote_datasource.dart';

class CouponRepositoryImpl implements CouponRepository {
  final CouponRemoteDataSource remoteDataSource;

  CouponRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Coupon>>> getCoupons() async {
    try {
      final coupons = await remoteDataSource.getCoupons();
      return Right(coupons);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}