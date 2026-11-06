import 'dart:math';

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/support_ticket.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_remote_datasource.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource remoteDataSource;
  SupportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SupportFaq>>> getFaqs() async {
    try {
      return Right(await remoteDataSource.getFaqs());
    } catch (_) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupportTicket>> createTicket({
    required String subject,
    required String description,
    required String category,
    required String email,
  }) async {
    try {
      final ticket = await remoteDataSource.createTicket(
        subject: subject,
        description: description,
        category: category,
        email: email,
      );
      return Right(ticket);
    } catch (_) {
      return Left(ServerFailure(e.toString()));
    }
  }
}



