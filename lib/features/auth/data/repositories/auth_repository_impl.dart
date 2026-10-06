import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> checkAuthStatus();
  Future<Either<Failure, User>> login({required String mobile});

  Future<Either<Failure, User>> verifyOtp({
    required String mobile,
    required String otp,
  });

  Future<Either<Failure, void>> logout();
}
