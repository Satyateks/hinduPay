import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String mobile;
  final String? email;
  final String? profileImage;

  const User({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
    this.profileImage,
  });

  @override
  List<Object?> get props => [id, name, mobile, email, profileImage];
}
