import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/store_home.dart';

abstract class StoreRepository {
  Future<Either<Failure, StoreHome>> getStoreHome();
}
