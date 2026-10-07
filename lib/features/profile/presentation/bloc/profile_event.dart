import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
    @override
  List<Object?> get props => [];
}

class RefreshProfile extends ProfileEvent {}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
  @override
  List<Object?> get props => [];
}

class GetProfileDetailsEvent extends ProfileEvent {}

class RefreshProfileEvent extends ProfileEvent {}
