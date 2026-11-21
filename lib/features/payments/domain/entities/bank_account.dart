import 'package:equatable/equatable.dart';

class BankAccount extends Equatable {
  final String id;
  final String bankName;
  final String accountNumberMasked;
  final double balance;
  final bool isPrimary;
  final String upiId;
  final String ifsc;
  final int brandColor;

  const BankAccount({
    required this.id,
    required this.bankName,
    required this.accountNumberMasked,
    required this.balance,
    this.isPrimary = false,
    required this.upiId,
    required this.ifsc,
    this.brandColor = 0xFF003366,
  });

  @override
  List<Object?> get props => [
    id,
    bankName,
    accountNumberMasked,
    balance,
    isPrimary,
    upiId,
    ifsc,
    brandColor,
  ];
}
