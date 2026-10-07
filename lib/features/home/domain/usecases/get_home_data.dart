import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/home_data.dart';
import '../repositories/home_repository.dart';

class GetHome {
  final HomeRepository repository;
  GetHome(this.repository);
  Future<Either<Failure, Home>> call() {return repository.getHome();}
}
