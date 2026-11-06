import 'package:equatable/equatable.dart';

class SupportFaq extends Equatable {
  final String id;
  final String question;
  final String answer;
  final String category;

  const SupportFaq({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
  });

  @override
  List<Object?> get props => [id, question, answer, category];
}




enum SupportTicketStatus { submitted, inProgress, resolved }

class SupportTicket extends Equatable {
  final String id;
  final String subject;
  final String description;
  final String category;
  final String email;
  final SupportTicketStatus status;
  final DateTime createdAt;

  const SupportTicket({
    required this.id,
    required this.subject,
    required this.description,
    required this.category,
    required this.email,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    subject,
    description,
    category,
    email,
    status,
    createdAt,
  ];
}
