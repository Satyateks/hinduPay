import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/pandit.dart';

abstract class PanditRepository {
  Future<Either<Failure, List<Pandit>>> getPandits({String? poojaFilter});

  Future<Either<Failure, List<PanditPoojaService>>> getPoojaServices({
    String? poojaFilter,
  });

  Future<Either<Failure, List<String>>> getPoojaCategories();

  Future<Either<Failure, List<SamagriItem>>> getSamagriCatalog();

  Future<Either<Failure, List<SamagriItem>>> getRecommendedSamagri();

  Future<Either<Failure, PanditPoojaService>> getPoojaServiceDetails(
    String serviceId,
  );

  Future<Either<Failure, bool>> toggleSamagriFavorite(String itemId);

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
  });
}
