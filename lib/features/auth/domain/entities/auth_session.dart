import 'package:equatable/equatable.dart';
import 'user.dart';

class AuthSession extends Equatable {
  final User user;
  final String accessToken;
  final String? refreshToken;

  const AuthSession({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}
