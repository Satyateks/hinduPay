import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/home_data.dart';

abstract class HomeRepository {
  Future<Either<Failure, Home>> getHome();
}
