import 'package:equatable/equatable.dart';

class SavedAddress extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String addressLine;
  final String city;
  final String state;
  final String pincode;
  final String type;
  final bool isDefault;

  const SavedAddress({
    required this.id,
    required this.name,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.pincode,
    this.type = 'Home',
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    addressLine,
    city,
    state,
    pincode,
    type,
    isDefault,
  ];
}
