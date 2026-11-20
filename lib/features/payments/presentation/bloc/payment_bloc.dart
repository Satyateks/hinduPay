import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/bank_transfer.dart';
import '../../domain/usecases/check_balance.dart';
import '../../domain/usecases/get_bank_accounts.dart';
import '../../domain/usecases/get_recent_contacts.dart';
import '../../domain/usecases/mobile_pay.dart';
import '../../domain/usecases/pay_bill.dart';
import '../../domain/usecases/scan_pay.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final ScanPay scanPay;
  final MobilePay mobilePay;
  final BankTransfer bankTransfer;
  final PayBill payBill;
  final CheckBalance checkBalance;
  final GetBankAccounts getBankAccounts;
  final GetRecentContacts getRecentContacts;

  PaymentBloc({
    required this.scanPay,
    required this.mobilePay,
    required this.bankTransfer,
    required this.payBill,
    required this.checkBalance,
    required this.getBankAccounts,
    required this.getRecentContacts,
  }) : super(const PaymentState()) {
    on<LoadUpiDashboard>(_onLoadUpiDashboard);
    on<ScanAndPaySubmitted>(_onScanAndPaySubmitted);
    on<MobilePaySubmitted>(_onMobilePaySubmitted);
    on<BankTransferSubmitted>(_onBankTransferSubmitted);
    on<BillPaySubmitted>(_onBillPaySubmitted);
    on<CheckBalanceRequested>(_onCheckBalanceRequested);
    on<ResetPaymentState>(_onResetPaymentState);
  }

  Future<void> _onLoadUpiDashboard(
    LoadUpiDashboard event,
    Emitter<PaymentState> emit,
  ) async {
    final accountsResult = await getBankAccounts();
    final contactsResult = await getRecentContacts();

    final bankAccounts = accountsResult.fold((_) => state.bankAccounts, (r) => r);
    final contacts = contactsResult.fold((_) => state.recentContacts, (r) => r);

    emit(state.copyWith(
      bankAccounts: bankAccounts,
      recentContacts: contacts,
    ));
  }

  Future<void> _onScanAndPaySubmitted(
    ScanAndPaySubmitted event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(status: PaymentBlocStatus.loading, errorMessage: null));

    final result = await scanPay(
      qrData: event.qrData,
      amount: event.amount,
      note: event.note,
      bankAccount: event.bankAccount,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: PaymentBlocStatus.failure,
        errorMessage: failure.message,
      )),
      (payment) => emit(state.copyWith(
        status: PaymentBlocStatus.success,
        currentPayment: payment,
      )),
    );
  }

  Future<void> _onMobilePaySubmitted(
    MobilePaySubmitted event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(status: PaymentBlocStatus.loading, errorMessage: null));

    final result = await mobilePay(
      mobile: event.mobile,
      amount: event.amount,
      recipientName: event.recipientName,
      note: event.note,
      bankAccount: event.bankAccount,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: PaymentBlocStatus.failure,
        errorMessage: failure.message,
      )),
      (payment) => emit(state.copyWith(
        status: PaymentBlocStatus.success,
        currentPayment: payment,
      )),
    );
  }

  Future<void> _onBankTransferSubmitted(
    BankTransferSubmitted event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(status: PaymentBlocStatus.loading, errorMessage: null));

    final result = await bankTransfer(
      accountNumber: event.accountNumber,
      ifsc: event.ifsc,
      amount: event.amount,
      accountHolderName: event.accountHolderName,
      note: event.note,
      bankAccount: event.bankAccount,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: PaymentBlocStatus.failure,
        errorMessage: failure.message,
      )),
      (payment) => emit(state.copyWith(
        status: PaymentBlocStatus.success,
        currentPayment: payment,
      )),
    );
  }

  Future<void> _onBillPaySubmitted(
    BillPaySubmitted event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(status: PaymentBlocStatus.loading, errorMessage: null));

    final result = await payBill(
      serviceTitle: event.serviceTitle,
      consumerNumber: event.consumerNumber,
      amount: event.amount,
      operatorName: event.operatorName,
      bankAccount: event.bankAccount,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: PaymentBlocStatus.failure,
        errorMessage: failure.message,
      )),
      (payment) => emit(state.copyWith(
        status: PaymentBlocStatus.success,
        currentPayment: payment,
      )),
    );
  }

  Future<void> _onCheckBalanceRequested(
    CheckBalanceRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(isCheckingBalance: true));

    final result = await checkBalance(
      accountId: event.accountId,
      upiPin: event.upiPin,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isCheckingBalance: false,
        errorMessage: failure.message,
      )),
      (balance) {
        final updatedMap = Map<String, double>.from(state.revealedBalances);
        updatedMap[event.accountId] = balance;
        emit(state.copyWith(
          isCheckingBalance: false,
          revealedBalances: updatedMap,
        ));
      },
    );
  }

  void _onResetPaymentState(
    ResetPaymentState event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(status: PaymentBlocStatus.initial, errorMessage: null));
  }
}
