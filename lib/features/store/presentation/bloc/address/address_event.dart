import 'package:equatable/equatable.dart';
import '../../../domain/entities/saved_address.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddresses extends AddressEvent {
  const LoadAddresses();
}

class AddAddressRequested extends AddressEvent {
  final SavedAddress address;
  const AddAddressRequested(this.address);

  @override
  List<Object?> get props => [address];
}

class UpdateAddressRequested extends AddressEvent {
  final SavedAddress address;
  const UpdateAddressRequested(this.address);
  @override
  List<Object?> get props => [address];
}

class DeleteAddressRequested extends AddressEvent {
  final String id;
  const DeleteAddressRequested(this.id);
  @override
  List<Object?> get props => [id];
}

class SelectAddressRequested extends AddressEvent {
  final String id;
  const SelectAddressRequested(this.id);
  @override
  List<Object?> get props => [id];
}
