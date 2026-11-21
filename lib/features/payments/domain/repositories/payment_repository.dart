import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/bank_account.dart';
import '../entities/payment.dart';
import '../entities/upi_contact.dart';

abstract class PaymentRepository {
  Future<Either<Failure, Payment>> scanAndPay({
    required String qrData,
    required double amount,
    String? note,
    String? bankAccount,
  });

  Future<Either<Failure, Payment>> mobilePay({
    required String mobile,
    required double amount,
    String? recipientName,
    String? note,
    String? bankAccount,
  });

  Future<Either<Failure, Payment>> bankTransfer({
    required String accountNumber,
    required String ifsc,
    required double amount,
    String? accountHolderName,
    String? note,
    String? bankAccount,
  });

  Future<Either<Failure, Payment>> payBill({
    required String serviceTitle,
    required String consumerNumber,
    required double amount,
    String? operatorName,
    String? bankAccount,
  });

  Future<Either<Failure, Payment>> getPaymentStatus({
    required String paymentId,
  });

  Future<Either<Failure, List<BankAccount>>> getBankAccounts();

  Future<Either<Failure, double>> checkBalance({
    required String accountId,
    required String upiPin,
  });

  Future<Either<Failure, List<UpiContact>>> getRecentContacts();
}
