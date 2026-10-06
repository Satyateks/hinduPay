import '../../domain/entities/auth_session.dart';
import 'user_model.dart';

class AuthResponseModel extends AuthSession {
  const AuthResponseModel({
    required super.user,
    required super.accessToken,
    super.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserModel.fromJson(json),
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString(),
    );
  }
}
