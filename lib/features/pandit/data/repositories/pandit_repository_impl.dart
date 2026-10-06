import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/pandit.dart';
import '../../domain/repositories/pandit_repository.dart';
import '../datasources/pandit_remote_datasource.dart';

class PanditRepositoryImpl implements PanditRepository {
  final PanditRemoteDataSource remoteDataSource;

  PanditRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Pandit>>> getPandits() async {
    try {
      final panditModels = await remoteDataSource.getPandits();
      return Right(panditModels);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
