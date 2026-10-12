import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/saved_address.dart';
import '../models/address_model.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<SavedAddress>>> getAddresses();
  Future<Either<Failure, SavedAddress>> addAddress(SavedAddress address);
  Future<Either<Failure, SavedAddress>> updateAddress(SavedAddress address);
  Future<Either<Failure, bool>> deleteAddress(String id);
  Future<Either<Failure, SavedAddress>> selectAddress(String id);
}

abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> addAddress(AddressModel address);
  Future<AddressModel> updateAddress(AddressModel address);
  Future<bool> deleteAddress(String id);
  Future<AddressModel> selectAddress(String id);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final List<AddressModel> _addresses = [
    const AddressModel(
      id: 'address_1',
      name: 'Rahul Sharma',
      phone: '98XXXXXX10',
      addressLine: 'Techzone 4',
      city: 'Greater Noida',
      state: 'Uttar Pradesh',
      pincode: '201310',
      type: 'Home',
      isDefault: true,
    ),
    const AddressModel(
      id: 'address_2',
      name: 'Rahul Sharma',
      phone: '98XXXXXX10',
      addressLine: 'Sector 18',
      city: 'Noida',
      state: 'Uttar Pradesh',
      pincode: '201301',
      type: 'Work',
    ),
  ];

  @override
  Future<List<AddressModel>> getAddresses() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_addresses);
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final saved = AddressModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: address.name,
      phone: address.phone,
      addressLine: address.addressLine,
      city: address.city,
      state: address.state,
      pincode: address.pincode,
      type: address.type,
      isDefault: address.isDefault || _addresses.isEmpty,
    );

    if (saved.isDefault) _makeDefaultLocally(saved.id);
    _addresses.add(saved);
    return saved;
  }

  @override
  Future<AddressModel> updateAddress(AddressModel address) async {
    final index = _addresses.indexWhere((a) => a.id == address.id);

    if (index == -1) throw Exception('Address not found');
    _addresses[index] = address;
    return address;
  }

  @override
  Future<bool> deleteAddress(String id) async {
    _addresses.removeWhere((a) => a.id == id);
    return true;
  }

  @override
  Future<AddressModel> selectAddress(String id) async {
    final index = _addresses.indexWhere((a) => a.id == id);

    if (index == -1) throw Exception('Address not found');

    _makeDefaultLocally(id);
    return _addresses.firstWhere((a) => a.id == id);
  }

  void _makeDefaultLocally(String id) {
    for (var i = 0; i < _addresses.length; i++) {
      final old = _addresses[i];

      _addresses[i] = AddressModel(
        id: old.id,
        name: old.name,
        phone: old.phone,
        addressLine: old.addressLine,
        city: old.city,
        state: old.state,
        pincode: old.pincode,
        type: old.type,
        isDefault: old.id == id,
      );
    }
  }
}

