import 'package:equatable/equatable.dart';

class Beneficiary extends Equatable {
  final String id;
  final String name;
  final String bankName;
  final String accountNumberMasked;
  final String accountNumber;
  final String ifsc;
  final String accountType;
  final int brandColor;

  const Beneficiary({
    required this.id,
    required this.name,
    required this.bankName,
    required this.accountNumberMasked,
    required this.accountNumber,
    required this.ifsc,
    this.accountType = 'Savings',
    this.brandColor = 0xFF003366,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    bankName,
    accountNumberMasked,
    accountNumber,
    ifsc,
    accountType,
    brandColor,
  ];
}
