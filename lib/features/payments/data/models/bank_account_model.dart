import '../../domain/entities/bank_account.dart';

class BankAccountModel extends BankAccount {
  const BankAccountModel({
    required super.id,
    required super.bankName,
    required super.accountNumberMasked,
    required super.balance,
    super.isPrimary,
    required super.upiId,
    required super.ifsc,
    super.brandColor,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      id: json['id'] as String,
      bankName: json['bankName'] as String,
      accountNumberMasked: json['accountNumberMasked'] as String,
      balance: (json['balance'] as num).toDouble(),
      isPrimary: json['isPrimary'] as bool? ?? false,
      upiId: json['upiId'] as String,
      ifsc: json['ifsc'] as String,
      brandColor: json['brandColor'] as int? ?? 0xFF003366,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankName': bankName,
      'accountNumberMasked': accountNumberMasked,
      'balance': balance,
      'isPrimary': isPrimary,
      'upiId': upiId,
      'ifsc': ifsc,
      'brandColor': brandColor,
    };
  }
}
