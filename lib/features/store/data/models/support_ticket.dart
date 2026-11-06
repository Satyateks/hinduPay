import '../../domain/entities/support_ticket.dart';

class SupportTicketModel extends SupportTicket {
  const SupportTicketModel({
    required super.id,
    required super.subject,
    required super.description,
    required super.category,
    required super.email,
    required super.status,
    required super.createdAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['id'] as String,
      subject: json['subject'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      email: json['email'] as String,
      status: SupportTicketStatus.values.firstWhere((value) => value.name == json['status'], orElse: () => SupportTicketStatus.submitted),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'description': description,
      'category': category,
      'email': email,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
