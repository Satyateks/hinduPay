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
  Future<Either<Failure, List<PanditPoojaService>>> getPoojaServices({
    String? poojaFilter,
  }) async {
    try {
      final services = await remoteDataSource.getPoojaServices(poojaFilter);
      return Right(services);
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
  Future<Either<Failure, List<SamagriItem>>> getSamagriCatalog() async {
    try {
      final items = await remoteDataSource.getSamagriCatalog();
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SamagriItem>>> getRecommendedSamagri() async {
    try {
      final items = await remoteDataSource.getRecommendedSamagri();
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PanditPoojaService>> getPoojaServiceDetails(
    String serviceId,
  ) async {
    try {
      final detail = await remoteDataSource.getPoojaServiceDetails(serviceId);
      return Right(detail);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleSamagriFavorite(String itemId) async {
    try {
      final isFavorite = await remoteDataSource.toggleSamagriFavorite(itemId);
      return Right(isFavorite);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PanditBookingConfirmation>> bookPandit({
    required String panditId,
    required String poojaName,
    required PanditDateOption date,
    required String timeSlot,
    required PanditServiceMode serviceMode,
    required PanditPaymentMode paymentMode,
    required PanditAddress address,
    required int totalPayable,
    required int totalSavings,
  }) async {
    try {
      final confirmation = await remoteDataSource.bookPandit(
        panditId: panditId,
        poojaName: poojaName,
        date: date,
        timeSlot: timeSlot,
        serviceMode: serviceMode,
        paymentMode: paymentMode,
        address: address,
        totalPayable: totalPayable,
        totalSavings: totalSavings,
      );
      return Right(confirmation);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
