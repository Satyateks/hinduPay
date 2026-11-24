import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/payment_repository.dart';

class CheckBalance {
  final PaymentRepository repository;

  CheckBalance(this.repository);

  Future<Either<Failure, double>> call({
    required String accountId,
    required String upiPin,
  }) {
    return repository.checkBalance(accountId: accountId, upiPin: upiPin);
  }
}
