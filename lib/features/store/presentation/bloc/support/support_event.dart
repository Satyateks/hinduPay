import 'package:equatable/equatable.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object?> get props => [];
}

class LoadSupportFaqs extends SupportEvent {
  const LoadSupportFaqs();
}

class SubmitSupportTicket extends SupportEvent {
  final String subject;
  final String description;
  final String category;
  final String email;

  const SubmitSupportTicket({
    required this.subject,
    required this.description,
    required this.category,
    required this.email,
  });

  @override
  List<Object?> get props => [subject, description, category, email];
}


class LoadStoreHome extends SupportEvent {
  const LoadStoreHome();
}
