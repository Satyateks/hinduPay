import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/bank_account.dart';
import '../repositories/payment_repository.dart';

class GetBankAccounts {
  final PaymentRepository repository;

  GetBankAccounts(this.repository);

  Future<Either<Failure, List<BankAccount>>> call() {
    return repository.getBankAccounts();
  }
}
