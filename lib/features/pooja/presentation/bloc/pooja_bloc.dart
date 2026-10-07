import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_pooja_categories.dart';
import '../../domain/usecases/get_pooja_details.dart';
import '../../domain/usecases/get_poojas.dart';

import 'pooja_event.dart';
import 'pooja_state.dart';

class PoojaBloc extends Bloc<PoojaEvent, PoojaState> {
  final GetPoojas getPoojas;
  final GetPoojaDetail getPoojaDetail;
  final GetPoojaCategories getPoojaCategories;

  PoojaBloc({
    required this.getPoojas,
    required this.getPoojaDetail,
    required this.getPoojaCategories,
  }) : super(const PoojaState()) {
    on<LoadPoojas>(_onLoadPoojas);
    on<LoadPoojaDetail>(_onLoadPoojaDetail);
    on<LoadPoojaCategories>(_onLoadCategories);
  }

  Future<void> _onLoadPoojas(LoadPoojas event, Emitter<PoojaState> emit) async {
    emit(state.copyWith(status: PoojaStatus.loading));

    try {
      final result = await getPoojas();

      emit(state.copyWith(status: PoojaStatus.success, poojas: result));
    } catch (e) {
      emit(
        state.copyWith(status: PoojaStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onLoadPoojaDetail(
    LoadPoojaDetail event,
    Emitter<PoojaState> emit,
  ) async {
    emit(state.copyWith(status: PoojaStatus.loading));

    try {
      final result = await getPoojaDetail(event.id);

      emit(state.copyWith(status: PoojaStatus.success, selectedPooja: result));
    } catch (e) {
      emit(
        state.copyWith(status: PoojaStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onLoadCategories(
    LoadPoojaCategories event,
    Emitter<PoojaState> emit,
  ) async {
    try {
      final result = await getPoojaCategories();

      emit(state.copyWith(categories: result));
    } catch (e) {
      emit(
        state.copyWith(status: PoojaStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
