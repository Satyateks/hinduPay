import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeStarted>(_onHomeStarted);
    on<HomeModuleChanged>(_onModuleChanged);
  }

  void _onHomeStarted(HomeStarted event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedModule: HomeModule.pooja));
  }

  void _onModuleChanged(HomeModuleChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedModule: event.module));
  }
}

/*
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeData getHomeData;

  HomeBloc({required this.getHomeData}) : super(const HomeState()) {
    on<LoadHome>(_onLoadHome);
    on<RefreshHome>(_onRefreshHome);
  }

  Future<void> _onLoadHome(LoadHome event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final result = await getHomeData();

    result.fold(
      (failure) {
        emit(
          state.copyWith(status: HomeStatus.failure, message: failure.message),
        );
      },
      (data) {
        emit(state.copyWith(status: HomeStatus.success, data: data));
      },
    );
  }

  Future<void> _onRefreshHome(
    RefreshHome event,
    Emitter<HomeState> emit,
  ) async {
    add(const LoadHome());
  }
}
*/