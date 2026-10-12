import 'package:equatable/equatable.dart';
import '../../../domain/entities/saved_address.dart';

enum AddressStatus { initial, loading, success, saving, failure }

class AddressState extends Equatable {
  final AddressStatus status;
  final List<SavedAddress> addresses;
  final String? errorMessage;

  const AddressState({
    this.status = AddressStatus.initial,
    this.addresses = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, addresses, errorMessage];
}
