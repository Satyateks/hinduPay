import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hindu_pay/features/home/domain/entities/home_data.dart';
import '../../domain/usecases/get_home_data.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHome getHome;

  HomeBloc({required this.getHome}) : super(const HomeState.initial()) {
    on<LoadHome>(_onLoadHome);
    on<RefreshHome>(_onRefreshHome);
  }

  Future<void> _onLoadHome(LoadHome event, Emitter<HomeState> emit) async {
    emit(const HomeState.loading());

    final result = await getHome();

    result.fold(
      (failure) {
        emit(HomeState.failure(failure.message));
      },
      (home) {
        emit(HomeState.success(home));
      },
    );
  }

  Future<void> _onRefreshHome(
    RefreshHome event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final home = await getHome();

      emit(HomeState.success(home as Home));
    } catch (e) {
      emit(HomeState.failure(e.toString()));
    }
  }
}
