import 'package:equatable/equatable.dart';

import '../../domain/entities/bank_account.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/upi_contact.dart';

enum PaymentBlocStatus { initial, loading, success, failure }

class PaymentState extends Equatable {
  final PaymentBlocStatus status;
  final Payment? currentPayment;
  final List<BankAccount> bankAccounts;
  final List<UpiContact> recentContacts;
  final Map<String, double> revealedBalances;
  final String? errorMessage;
  final bool isCheckingBalance;

  const PaymentState({
    this.status = PaymentBlocStatus.initial,
    this.currentPayment,
    this.bankAccounts = const [],
    this.recentContacts = const [],
    this.revealedBalances = const {},
    this.errorMessage,
    this.isCheckingBalance = false,
  });

  PaymentState copyWith({
    PaymentBlocStatus? status,
    Payment? currentPayment,
    List<BankAccount>? bankAccounts,
    List<UpiContact>? recentContacts,
    Map<String, double>? revealedBalances,
    String? errorMessage,
    bool? isCheckingBalance,
  }) {
    return PaymentState(
      status: status ?? this.status,
      currentPayment: currentPayment ?? this.currentPayment,
      bankAccounts: bankAccounts ?? this.bankAccounts,
      recentContacts: recentContacts ?? this.recentContacts,
      revealedBalances: revealedBalances ?? this.revealedBalances,
      errorMessage: errorMessage,
      isCheckingBalance: isCheckingBalance ?? this.isCheckingBalance,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentPayment,
    bankAccounts,
    recentContacts,
    revealedBalances,
    errorMessage,
    isCheckingBalance,
  ];
}
