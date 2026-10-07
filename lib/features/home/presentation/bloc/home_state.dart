import 'package:equatable/equatable.dart';
import '../../domain/entities/home_data.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final Home? home;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.home,
    this.errorMessage,
  });

  const HomeState.initial()
    : status = HomeStatus.initial,
      home = null,
      errorMessage = null;

  const HomeState.loading()
    : status = HomeStatus.loading,
      home = null,
      errorMessage = null;

  const HomeState.success(Home data)
    : status = HomeStatus.success,
      home = data,
      errorMessage = null;

  const HomeState.failure(String message)
    : status = HomeStatus.failure,
      home = null,
      errorMessage = message;

  @override
  List<Object?> get props => [status, home, errorMessage];
}
