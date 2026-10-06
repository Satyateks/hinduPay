import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/pandit.dart';

abstract class PanditRepository {
  // Pooja filter ke sath ya bina filter ke list lane ke liye
  Future<Either<Failure, List<Pandit>>> getPandits({String? poojaFilter});
  Future<Either<Failure, List<String>>> getPoojaCategories();
  Future<Either<Failure, bool>> bookPandit({required String panditId, required String poojaName, required DateTime date});
}