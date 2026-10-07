import 'dart:math';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Home>> getHome() async {
    try {
      final result = await remoteDataSource.getHome();
      return Right(result);
    } on Exception {
      return Left(ServerFailure(e.toString()));
    }
  }
}