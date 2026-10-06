import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/check_auth_status.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/verify_otp.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final VerifyOtp verifyOtp;
  final Logout logout;
  final CheckAuthStatus checkAuthStatus;

  AuthBloc({
    required this.login,
    required this.verifyOtp,
    required this.logout,
    required this.checkAuthStatus,
  }) : super(const AuthState()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);

    on<LoginRequested>(_onLoginRequested);

    on<VerifyOtpRequested>(_onVerifyOtpRequested);

    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await checkAuthStatus();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            message: failure.message,
          ),
        );
      },
      (isAuthenticated) {
        emit(
          state.copyWith(
            status: isAuthenticated
                ? AuthStatus.authenticated
                : AuthStatus.unauthenticated,
          ),
        );
      },
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        message: null,
        mobile: event.mobile,
      ),
    );
    final result = await login(mobile: event.mobile);
    result.fold(
      (failure) {emit(state.copyWith(status: AuthStatus.failure, message: failure.message));},
      (_) {emit(state.copyWith(status: AuthStatus.otpSent, mobile: event.mobile));},
    );
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));

    final result = await verifyOtp(mobile: event.mobile, otp: event.otp);

    result.fold(
      (failure) {
        emit(
          state.copyWith(status: AuthStatus.failure, message: failure.message),
        );
      },
      (session) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            // user: session.user,
          ),
        );
      },
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await logout();

    result.fold(
      (failure) {
        emit(
          state.copyWith(status: AuthStatus.failure, message: failure.message),
        );
      },
      (_) {
        emit(const AuthState(status: AuthStatus.unauthenticated));
      },
    );
  }
}
