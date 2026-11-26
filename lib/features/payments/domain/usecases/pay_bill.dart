import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class PayBill {
  final PaymentRepository repository;

  PayBill(this.repository);

  Future<Either<Failure, Payment>> call({
    required String serviceTitle,
    required String consumerNumber,
    required double amount,
    String? operatorName,
    String? bankAccount,
  }) {
    return repository.payBill(
      serviceTitle: serviceTitle,
      consumerNumber: consumerNumber,
      amount: amount,
      operatorName: operatorName,
      bankAccount: bankAccount,
    );
  }
}
