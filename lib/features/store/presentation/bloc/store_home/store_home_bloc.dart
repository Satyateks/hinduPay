import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_store_home.dart';
import 'store_home_event.dart';
import 'store_home_state.dart';

class StoreHomeBloc extends Bloc<StoreHomeEvent, StoreHomeState> {
  final GetStoreHome getStoreHome;

  StoreHomeBloc({required this.getStoreHome})
    : super(const StoreHomeState.initial()) {
    on<LoadStoreHome>(_onLoadStoreHome);
    on<RefreshStoreHome>(_onRefreshStoreHome);
  }

  Future<void> _onLoadStoreHome(
    LoadStoreHome event,
    Emitter<StoreHomeState> emit,
  ) async {
    emit(const StoreHomeState.loading());

    final result = await getStoreHome();

    result.fold(
      (failure) {
        emit(StoreHomeState.failure(failure.message));
      },
      (storeHome) {
        emit(StoreHomeState.success(storeHome));
      },
    );
  }

  Future<void> _onRefreshStoreHome(
    RefreshStoreHome event,
    Emitter<StoreHomeState> emit,
  ) async {
    final result = await getStoreHome();

    result.fold(
      (failure) {
        emit(StoreHomeState.failure(failure.message));
      },
      (storeHome) {
        emit(StoreHomeState.success(storeHome));
      },
    );
  }
}
