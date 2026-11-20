import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class GetPaymentStatus {
  final PaymentRepository repository;

  GetPaymentStatus(this.repository);

  Future<Either<Failure, Payment>> call({required String paymentId}) {
    return repository.getPaymentStatus(paymentId: paymentId);
  }
}
