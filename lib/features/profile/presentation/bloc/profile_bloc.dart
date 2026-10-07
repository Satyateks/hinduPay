import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_user_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileDetails getProfileDetails;

  ProfileBloc({required this.getProfileDetails}) : super(ProfileInitial()) {
    on<GetProfileDetailsEvent>(_onGetProfileDetails);
    on<RefreshProfileEvent>(_onRefreshProfile);
  }

  Future<void> _onGetProfileDetails(
    GetProfileDetailsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await getProfileDetails();

    result.fold(
      (failure) {
        emit(ProfileError(failure.message));
      },
      (user) {
        emit(ProfileLoaded(user));
      },
    );
  }

  Future<void> _onRefreshProfile(
    RefreshProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await getProfileDetails();

    result.fold(
      (failure) {
        emit(ProfileError(failure.message));
      },
      (user) {
        emit(ProfileLoaded(user));
      },
    );
  }
}
