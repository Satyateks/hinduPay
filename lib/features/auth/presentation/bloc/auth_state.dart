import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

enum AuthStatus {
  initial,
  loading,
  unauthenticated,
  otpSent,
  authenticated,
  failure,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? mobile;
  final String? message;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.mobile,
    this.message,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? mobile,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      mobile: mobile ?? this.mobile,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, user, mobile, message];
}
