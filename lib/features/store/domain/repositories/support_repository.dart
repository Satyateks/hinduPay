import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/support_ticket.dart';

abstract class SupportRepository {
  Future<Either<Failure, List<SupportFaq>>> getFaqs();
  Future<Either<Failure, SupportTicket>> createTicket({
    required String subject,
    required String description,
    required String category,
    required String email,
  });
}
