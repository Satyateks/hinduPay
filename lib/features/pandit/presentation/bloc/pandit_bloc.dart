import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_pandits.dart';
import 'pandit_event.dart';
import 'pandit_state.dart';

class PanditBloc extends Bloc<PanditEvent, PanditState> {
  final GetPandits getPandits;

  PanditBloc({required this.getPandits}) : super(const PanditState()) {
    on<FetchPanditsEvent>(_onFetchPandits);
  }

  Future<void> _onFetchPandits(
    FetchPanditsEvent event,
    Emitter<PanditState> emit,
  ) async {
    emit(state.copyWith(status: PanditStatus.loading));

    final result = await getPandits();

    result.fold(
      (failure) => emit(
        state.copyWith(status: PanditStatus.failure, message: failure.message),
      ),
      (pandits) =>
          emit(state.copyWith(status: PanditStatus.loaded, pandits: pandits)),
    );
  }
}
