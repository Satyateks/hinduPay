import '../../../../core/errors/failures.dart';
import '../../data/models/profile_modele.dart';
import '../repositories/profile_repository.dart';

import 'package:dartz/dartz.dart';

class GetProfileDetails {
  final ProfileRepository repository;

  GetProfileDetails({required this.repository});

  Future<Either<Failure, ProfileModels>> call() async {
    return await repository.getProfileDetails();
  }
}
