import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/support_ticket.dart';
import '../repositories/support_repository.dart';

class GetSupportFaqs {
  final SupportRepository repository;
  GetSupportFaqs(this.repository);
  Future<Either<Failure, List<SupportFaq>>> call() {return repository.getFaqs();}
}


class CreateSupportTicket {
  final SupportRepository repository;
  CreateSupportTicket(this.repository);
  Future<Either<Failure, SupportTicket>> call({
    required String subject,
    required String description,
    required String category,
    required String email,
  }) {
    return repository.createTicket(
      subject: subject,
      description: description,
      category: category,
      email: email,
    );
  }
}
