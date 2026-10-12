// get_saved_addresses.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/address_remote_datasource.dart';
import '../entities/saved_address.dart';

class GetSavedAddresses {
  final AddressRepository repository;
  GetSavedAddresses(this.repository);

  Future<Either<Failure, List<SavedAddress>>> call() => repository.getAddresses();
}
