// address_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/saved_address.dart';
import '../datasources/address_remote_datasource.dart';
import '../models/address_model.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SavedAddress>>> getAddresses() async {
    try {
      return Right(await remoteDataSource.getAddresses());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavedAddress>> addAddress(SavedAddress address) async {
    try {
      return Right(await remoteDataSource.addAddress(_toModel(address)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavedAddress>> updateAddress(
    SavedAddress address,
  ) async {
    try {
      return Right(await remoteDataSource.updateAddress(_toModel(address)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAddress(String id) async {
    try {
      return Right(await remoteDataSource.deleteAddress(id));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SavedAddress>> selectAddress(String id) async {
    try {
      return Right(await remoteDataSource.selectAddress(id));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  AddressModel _toModel(SavedAddress a) => AddressModel(
    id: a.id,
    name: a.name,
    phone: a.phone,
    addressLine: a.addressLine,
    city: a.city,
    state: a.state,
    pincode: a.pincode,
    type: a.type,
    isDefault: a.isDefault,
  );
}
