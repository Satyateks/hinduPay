import 'package:equatable/equatable.dart';

enum PaymentStatus { pending, processing, success, failed, cancelled }

class Payment extends Equatable {
  final String id;
  final double amount;
  final String? transactionId;
  final PaymentStatus status;

  const Payment({
    required this.id,
    required this.amount,
    this.transactionId,
    required this.status,
  });

  @override
  List<Object?> get props => [id, amount, transactionId, status];
}
