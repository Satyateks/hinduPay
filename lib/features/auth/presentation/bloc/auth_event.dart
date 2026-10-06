import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class LoginRequested extends AuthEvent {
  final String mobile;
  const LoginRequested({required this.mobile});
  @override
  List<Object?> get props => [mobile];
}

class VerifyOtpRequested extends AuthEvent {
  final String mobile;
  final String otp;
  const VerifyOtpRequested({required this.mobile, required this.otp});

  @override
  List<Object?> get props => [mobile, otp];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
