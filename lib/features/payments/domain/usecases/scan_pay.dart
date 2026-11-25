import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class ScanPay {
  final PaymentRepository repository;

  ScanPay(this.repository);

  Future<Either<Failure, Payment>> call({
    required String qrData,
    required double amount,
    String? note,
    String? bankAccount,
  }) {
    return repository.scanAndPay(
      qrData: qrData,
      amount: amount,
      note: note,
      bankAccount: bankAccount,
    );
  }
}
