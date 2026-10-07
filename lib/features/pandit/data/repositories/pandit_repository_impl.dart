import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/pandit.dart';
import '../../domain/repositories/pandit_repository.dart';
import '../datasources/pandit_remote_datasource.dart';

class PanditRepositoryImpl implements PanditRepository {
  final PanditRemoteDataSource remoteDataSource;

  PanditRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Pandit>>> getPandits({String? poojaFilter}) async {
    try {
      final panditModels = await remoteDataSource.getPandits(poojaFilter);
      return Right(panditModels);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getPoojaCategories() async {
    try {
      final categories = await remoteDataSource.getPoojaCategories();
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> bookPandit({
    required String panditId,
    required String poojaName,
    required DateTime date,
  }) async {
    try {
      final result = await remoteDataSource.bookPandit(
        panditId: panditId,
        poojaName: poojaName,
        date: date,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}