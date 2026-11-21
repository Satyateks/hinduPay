import '../../domain/entities/upi_contact.dart';

class UpiContactModel extends UpiContact {
  const UpiContactModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.upiId,
    super.avatarUrl,
    super.lastAmount,
  });

  factory UpiContactModel.fromJson(Map<String, dynamic> json) {
    return UpiContactModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      upiId: json['upiId'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      lastAmount: json['lastAmount'] != null ? (json['lastAmount'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'upiId': upiId,
      'avatarUrl': avatarUrl,
      'lastAmount': lastAmount,
    };
  }
}
