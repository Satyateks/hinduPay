import 'package:equatable/equatable.dart';

enum PaymentStatus {pending, processing, success, failed, cancelled}

enum PaymentType {
  scanAndPay,
  mobilePay,
  bankTransfer,
  upiId,
  mobileRecharge,
  billPayment,
}

class Payment extends Equatable {
  final String id;
  final double amount;
  final String? transactionId;
  final PaymentStatus status;
  final PaymentType type;
  final String? recipientName;
  final String? recipientUpiId;
  final String? bankAccount;
  final String? note;
  final DateTime timestamp;

  const Payment({
    required this.id,
    required this.amount,
    this.transactionId,
    required this.status,
    this.type = PaymentType.mobilePay,
    this.recipientName,
    this.recipientUpiId,
    this.bankAccount,
    this.note,
    required this.timestamp,
  });

  Payment copyWith({
    String? id,
    double? amount,
    String? transactionId,
    PaymentStatus? status,
    PaymentType? type,
    String? recipientName,
    String? recipientUpiId,
    String? bankAccount,
    String? note,
    DateTime? timestamp,
  }) {
    return Payment(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      transactionId: transactionId ?? this.transactionId,
      status: status ?? this.status,
      type: type ?? this.type,
      recipientName: recipientName ?? this.recipientName,
      recipientUpiId: recipientUpiId ?? this.recipientUpiId,
      bankAccount: bankAccount ?? this.bankAccount,
      note: note ?? this.note,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [
    id,
    amount,
    transactionId,
    status,
    type,
    recipientName,
    recipientUpiId,
    bankAccount,
    note,
    timestamp,
  ];
}
