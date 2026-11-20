import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class MobilePay {
  final PaymentRepository repository;

  MobilePay(this.repository);

  Future<Either<Failure, Payment>> call({
    required String mobile,
    required double amount,
    String? recipientName,
    String? note,
    String? bankAccount,
  }) {
    return repository.mobilePay(
      mobile: mobile,
      amount: amount,
      recipientName: recipientName,
      note: note,
      bankAccount: bankAccount,
    );
  }
}
