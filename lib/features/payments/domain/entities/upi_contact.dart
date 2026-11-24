import 'package:equatable/equatable.dart';

class UpiContact extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String upiId;
  final String? avatarUrl;
  final double? lastAmount;

  const UpiContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.upiId,
    this.avatarUrl,
    this.lastAmount,
  });

  @override
  List<Object?> get props => [id, name, phone, upiId, avatarUrl, lastAmount];
}
