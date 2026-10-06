import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_session.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> checkAuthStatus();

  Future<Either<Failure, void>> login({
    required String mobile,
  });

  Future<Either<Failure, AuthSession>> verifyOtp({
    required String mobile,
    required String otp,
  });

  Future<Either<Failure, void>> logout();
}


