import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/store_home.dart';
import '../repositories/store_repository.dart';

class GetStoreHome {
  final StoreRepository repository;
  GetStoreHome(this.repository);
  Future<Either<Failure, StoreHome>> call() {
    return repository.getStoreHome();
  }
}
