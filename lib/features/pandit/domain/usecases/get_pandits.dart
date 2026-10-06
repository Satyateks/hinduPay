import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/pandit.dart';
import '../repositories/pandit_repository.dart';

class GetPandits {
  final PanditRepository repository;

  GetPandits({required this.repository});

  Future<Either<Failure, List<Pandit>>> call() async {
    return await repository.getPandits();
  }
}
