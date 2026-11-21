import '../../domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.amount,
    super.transactionId,
    required super.status,
    super.type,
    super.recipientName,
    super.recipientUpiId,
    super.bankAccount,
    super.note,
    required super.timestamp,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      transactionId: json['transactionId'] as String?,
      status: _statusFromString(json['status'] as String?),
      type: _typeFromString(json['type'] as String?),
      recipientName: json['recipientName'] as String?,
      recipientUpiId: json['recipientUpiId'] as String?,
      bankAccount: json['bankAccount'] as String?,
      note: json['note'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'transactionId': transactionId,
      'status': status.name,
      'type': type.name,
      'recipientName': recipientName,
      'recipientUpiId': recipientUpiId,
      'bankAccount': bankAccount,
      'note': note,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static PaymentStatus _statusFromString(String? status) {
    switch (status) {
      case 'processing':
        return PaymentStatus.processing;
      case 'success':
        return PaymentStatus.success;
      case 'failed':
        return PaymentStatus.failed;
      case 'cancelled':
        return PaymentStatus.cancelled;
      default:
        return PaymentStatus.pending;
    }
  }

  static PaymentType _typeFromString(String? type) {
    switch (type) {
      case 'scanAndPay':
        return PaymentType.scanAndPay;
      case 'mobilePay':
        return PaymentType.mobilePay;
      case 'bankTransfer':
        return PaymentType.bankTransfer;
      case 'upiId':
        return PaymentType.upiId;
      case 'mobileRecharge':
        return PaymentType.mobileRecharge;
      case 'billPayment':
        return PaymentType.billPayment;
      default:
        return PaymentType.mobilePay;
    }
  }
}
