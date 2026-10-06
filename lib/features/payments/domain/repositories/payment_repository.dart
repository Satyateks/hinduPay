import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';

abstract class PaymentRepository {
  Future<Either<Failure, Payment>> scanAndPay({
    required String qrData,
    required double amount,
  });

  Future<Either<Failure, Payment>> mobilePay({
    required String mobile,
    required double amount,
  });

  Future<Either<Failure, Payment>> bankTransfer({
    required String accountNumber,
    required String ifsc,
    required double amount,
  });

  Future<Either<Failure, Payment>> getPaymentStatus({
    required String paymentId
  });
}
