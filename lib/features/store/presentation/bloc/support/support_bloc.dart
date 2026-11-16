
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_support_ticket.dart';
import 'support_event.dart';
import 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final GetSupportFaqs getSupportFaqs;
  final CreateSupportTicket createSupportTicket;

  SupportBloc({
    required this.getSupportFaqs,
    required this.createSupportTicket,
  }) : super(const SupportState()) {
    on<LoadSupportFaqs>(_onLoadFaqs);
    on<SubmitSupportTicket>(_onSubmitTicket);
  }

  Future<void> _onLoadFaqs(LoadSupportFaqs event,Emitter<SupportState> emit) async {
    emit(state.copyWith(status: SupportStatus.loading,clearError: true));
    final result = await getSupportFaqs();

    result.fold(
      (failure) => emit(state.copyWith(status: SupportStatus.failure,errorMessage: failure.message)),
      (faqs) => emit(state.copyWith(status: SupportStatus.success,faqs: faqs,clearError: true)),
    );
  }

  Future<void> _onSubmitTicket(SubmitSupportTicket event,Emitter<SupportState> emit) async {
    emit(state.copyWith(
      status: SupportStatus.submitting,
      clearTicket: true,
      clearError: true,
    ));

    final result = await createSupportTicket(
      subject: event.subject,
      description: event.description,
      category: event.category,
      email: event.email,
    );

    result.fold(
      (failure) => emit(state.copyWith(status: SupportStatus.failure,errorMessage: failure.message)),
      (ticket) => emit(state.copyWith(status: SupportStatus.ticketCreated,ticket: ticket,clearError: true)),
    );
  }
}