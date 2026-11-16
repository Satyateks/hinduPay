import 'package:equatable/equatable.dart';
import '../../../domain/entities/support_ticket.dart';

enum SupportStatus {
  initial,
  loading,
  success,
  submitting,
  ticketCreated,
  failure,
}

class SupportState extends Equatable {
  final SupportStatus status;
  final List<SupportFaq> faqs;
  final SupportTicket? ticket;
  final String? errorMessage;

  const SupportState({
    this.status = SupportStatus.initial,
    this.faqs = const [],
    this.ticket,
    this.errorMessage,
  });

  SupportState copyWith({
    SupportStatus? status,
    List<SupportFaq>? faqs,
    SupportTicket? ticket,
    String? errorMessage,
    bool clearTicket = false,
    bool clearError = false,
  }) {
    return SupportState(
      status: status ?? this.status,
      faqs: faqs ?? this.faqs,
      ticket: clearTicket ? null : (ticket ?? this.ticket),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, faqs, ticket, errorMessage];
}
