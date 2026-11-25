import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class BankTransfer {
  final PaymentRepository repository;

  BankTransfer(this.repository);

  Future<Either<Failure, Payment>> call({
    required String accountNumber,
    required String ifsc,
    required double amount,
    String? accountHolderName,
    String? note,
    String? bankAccount,
  }) {
    return repository.bankTransfer(
      accountNumber: accountNumber,
      ifsc: ifsc,
      amount: amount,
      accountHolderName: accountHolderName,
      note: note,
      bankAccount: bankAccount,
    );
  }
}
