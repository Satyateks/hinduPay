import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/repositories/auth_repository_impl.dart';

class CheckAuthStatus {
  final AuthRepository repository;

  CheckAuthStatus({required this.repository});

  Future<Either<Failure, bool>> call() {
    return repository.checkAuthStatus();
  }
}
