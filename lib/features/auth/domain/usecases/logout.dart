import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/repositories/auth_repository_impl.dart';

class Logout {
  final AuthRepository repository;

  Logout({required this.repository});

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
