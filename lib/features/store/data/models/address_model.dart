import '../../domain/entities/saved_address.dart';

class AddressModel extends SavedAddress {
  const AddressModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.addressLine,
    required super.city,
    required super.state,
    required super.pincode,
    super.type,
    super.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      addressLine: json['address_line']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      type: json['type']?.toString() ?? 'Home',
      isDefault: json['is_default'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'address_line': addressLine,
    'city': city,
    'state': state,
    'pincode': pincode,
    'type': type,
    'is_default': isDefault,
  };
}
