import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/bank_account.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/upi_contact.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Payment>> scanAndPay({
    required String qrData,
    required double amount,
    String? note,
    String? bankAccount,
  }) async {
    try {
      final result = await remoteDataSource.scanAndPay(
        qrData: qrData,
        amount: amount,
        note: note,
        bankAccount: bankAccount,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Payment>> mobilePay({
    required String mobile,
    required double amount,
    String? recipientName,
    String? note,
    String? bankAccount,
  }) async {
    try {
      final result = await remoteDataSource.mobilePay(
        mobile: mobile,
        amount: amount,
        recipientName: recipientName,
        note: note,
        bankAccount: bankAccount,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Payment>> bankTransfer({
    required String accountNumber,
    required String ifsc,
    required double amount,
    String? accountHolderName,
    String? note,
    String? bankAccount,
  }) async {
    try {
      final result = await remoteDataSource.bankTransfer(
        accountNumber: accountNumber,
        ifsc: ifsc,
        amount: amount,
        accountHolderName: accountHolderName,
        note: note,
        bankAccount: bankAccount,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Payment>> payBill({
    required String serviceTitle,
    required String consumerNumber,
    required double amount,
    String? operatorName,
    String? bankAccount,
  }) async {
    try {
      final result = await remoteDataSource.payBill(
        serviceTitle: serviceTitle,
        consumerNumber: consumerNumber,
        amount: amount,
        operatorName: operatorName,
        bankAccount: bankAccount,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Payment>> getPaymentStatus({
    required String paymentId,
  }) async {
    try {
      final result = await remoteDataSource.getPaymentStatus(
        paymentId: paymentId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BankAccount>>> getBankAccounts() async {
    try {
      final result = await remoteDataSource.getBankAccounts();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> checkBalance({
    required String accountId,
    required String upiPin,
  }) async {
    try {
      final result = await remoteDataSource.checkBalance(
        accountId: accountId,
        upiPin: upiPin,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UpiContact>>> getRecentContacts() async {
    try {
      final result = await remoteDataSource.getRecentContacts();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
