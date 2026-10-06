import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../entities/user.dart';

class VerifyOtp {
  final AuthRepository repository;

  VerifyOtp({required this.repository});

  Future<Either<Failure, User>> call({
    required String mobile,
    required String otp,
  }) {
    return repository.verifyOtp(mobile: mobile, otp: otp);
  }
}
