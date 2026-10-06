import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/home_data.dart';
import '../repositories/home_repository.dart';

class GetHomeData {
  final HomeRepository repository;
  GetHomeData({required this.repository});
  Future<Either<Failure, HomeData>> call() {
    return repository.getHomeData();
  }
}
