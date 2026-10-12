import 'package:equatable/equatable.dart';

import '../../../domain/entities/store_home.dart';

enum StoreHomeStatus { initial, loading, success, failure }

class StoreHomeState extends Equatable {
  final StoreHomeStatus status;
  final StoreHome? storeHome;
  final String? errorMessage;

  const StoreHomeState({
    this.status = StoreHomeStatus.initial,
    this.storeHome,
    this.errorMessage,
  });

  const StoreHomeState.initial()
    : status = StoreHomeStatus.initial,
      storeHome = null,
      errorMessage = null;

  const StoreHomeState.loading()
    : status = StoreHomeStatus.loading,
      storeHome = null,
      errorMessage = null;

  const StoreHomeState.success(StoreHome data)
    : status = StoreHomeStatus.success,
      storeHome = data,
      errorMessage = null;

  const StoreHomeState.failure(String message)
    : status = StoreHomeStatus.failure,
      storeHome = null,
      errorMessage = message;

  @override
  List<Object?> get props => [status, storeHome, errorMessage];
}
