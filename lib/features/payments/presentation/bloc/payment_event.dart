import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class LoadUpiDashboard extends PaymentEvent {
  const LoadUpiDashboard();
}

class ScanAndPaySubmitted extends PaymentEvent {
  final String qrData;
  final double amount;
  final String? note;
  final String? bankAccount;

  const ScanAndPaySubmitted({
    required this.qrData,
    required this.amount,
    this.note,
    this.bankAccount,
  });

  @override
  List<Object?> get props => [qrData, amount, note, bankAccount];
}

class MobilePaySubmitted extends PaymentEvent {
  final String mobile;
  final double amount;
  final String? recipientName;
  final String? note;
  final String? bankAccount;

  const MobilePaySubmitted({
    required this.mobile,
    required this.amount,
    this.recipientName,
    this.note,
    this.bankAccount,
  });

  @override
  List<Object?> get props => [
    mobile,
    amount,
    recipientName,
    note,
    bankAccount,
  ];
}

class BankTransferSubmitted extends PaymentEvent {
  final String accountNumber;
  final String ifsc;
  final double amount;
  final String? accountHolderName;
  final String? note;
  final String? bankAccount;

  const BankTransferSubmitted({
    required this.accountNumber,
    required this.ifsc,
    required this.amount,
    this.accountHolderName,
    this.note,
    this.bankAccount,
  });

  @override
  List<Object?> get props => [
    accountNumber,
    ifsc,
    amount,
    accountHolderName,
    note,
    bankAccount,
  ];
}

class BillPaySubmitted extends PaymentEvent {
  final String serviceTitle;
  final String consumerNumber;
  final double amount;
  final String? operatorName;
  final String? bankAccount;

  const BillPaySubmitted({
    required this.serviceTitle,
    required this.consumerNumber,
    required this.amount,
    this.operatorName,
    this.bankAccount,
  });

  @override
  List<Object?> get props => [
    serviceTitle,
    consumerNumber,
    amount,
    operatorName,
    bankAccount,
  ];
}

class CheckBalanceRequested extends PaymentEvent {
  final String accountId;
  final String upiPin;

  const CheckBalanceRequested({
    required this.accountId,
    required this.upiPin,
  });

  @override
  List<Object?> get props => [accountId, upiPin];
}

class ResetPaymentState extends PaymentEvent {
  const ResetPaymentState();
}
