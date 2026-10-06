import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.mobile,
    super.email,
    super.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim(),
      mobile: json['phone']?.toString() ?? '',
      email: json['email']?.toString(),
      profileImage: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'profile_image': profileImage,
    };
  }
}
