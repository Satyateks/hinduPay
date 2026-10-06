import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../entities/user.dart';

class Login {
  final AuthRepository repository;
  Login({required this.repository});

  Future<Either<Failure, User>> call({required String mobile}) {
    return repository.login(mobile: mobile);
  }
}
