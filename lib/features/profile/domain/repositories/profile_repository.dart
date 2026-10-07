import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/profile_modele.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileModels>> getProfileDetails();
}

