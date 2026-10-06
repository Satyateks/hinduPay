import 'package:equatable/equatable.dart';
import 'home_state.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class HomeModuleChanged extends HomeEvent {
  final HomeModule module;
  const HomeModuleChanged(this.module);

  @override
  List<Object?> get props => [module];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}


/*
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class LoadHome extends HomeEvent {
  const LoadHome();
}

class RefreshHome extends HomeEvent {
  const RefreshHome();
}
*/