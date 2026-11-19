import '../models/bank_account_model.dart';
import '../models/payment_model.dart';
import '../models/upi_contact_model.dart';
import '../../domain/entities/payment.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> scanAndPay({
    required String qrData,
    required double amount,
    String? note,
    String? bankAccount,
  });

  Future<PaymentModel> mobilePay({
    required String mobile,
    required double amount,
    String? recipientName,
    String? note,
    String? bankAccount,
  });

  Future<PaymentModel> bankTransfer({
    required String accountNumber,
    required String ifsc,
    required double amount,
    String? accountHolderName,
    String? note,
    String? bankAccount,
  });

  Future<PaymentModel> payBill({
    required String serviceTitle,
    required String consumerNumber,
    required double amount,
    String? operatorName,
    String? bankAccount,
  });

  Future<PaymentModel> getPaymentStatus({required String paymentId});

  Future<List<BankAccountModel>> getBankAccounts();

  Future<double> checkBalance({
    required String accountId,
    required String upiPin,
  });

  Future<List<UpiContactModel>> getRecentContacts();
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final List<BankAccountModel> _bankAccounts = [
    const BankAccountModel(
      id: 'bank_yes_01',
      bankName: 'Yes Bank',
      accountNumberMasked: 'XX 3287',
      balance: 48250.75,
      isPrimary: true,
      upiId: 'user@yesbank',
      ifsc: 'YESB0000123',
      brandColor: 0xFF003B73,
    ),
    const BankAccountModel(
      id: 'bank_axis_02',
      bankName: 'Axis Bank',
      accountNumberMasked: 'XX 4398',
      balance: 12400.00,
      isPrimary: false,
      upiId: 'user@axisbank',
      ifsc: 'UTIB0000456',
      brandColor: 0xFF97144D,
    ),
  ];

  final List<UpiContactModel> _contacts = [
    const UpiContactModel(
      id: 'cnt_1',
      name: 'Ramesh Sharma',
      phone: '+91 98765 43210',
      upiId: 'ramesh.sharma@okaxis',
      lastAmount: 500,
    ),
    const UpiContactModel(
      id: 'cnt_2',
      name: 'Priya Patel',
      phone: '+91 98234 56789',
      upiId: 'priya.patel@okhdfcbank',
      lastAmount: 1100,
    ),
    const UpiContactModel(
      id: 'cnt_3',
      name: 'Temple Trust Fund',
      phone: '+91 94123 45678',
      upiId: 'templetrust@upi',
      lastAmount: 2100,
    ),
    const UpiContactModel(
      id: 'cnt_4',
      name: 'Pandit Rajesh Ji',
      phone: '+91 98901 23456',
      upiId: 'rajesh.pandit@ybl',
      lastAmount: 1500,
    ),
    const UpiContactModel(
      id: 'cnt_5',
      name: 'Ananya Gupta',
      phone: '+91 97654 32109',
      upiId: 'ananya.gupta@paytm',
      lastAmount: 250,
    ),
  ];

  final Map<String, PaymentModel> _payments = {};

  @override
  Future<List<BankAccountModel>> getBankAccounts() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _bankAccounts;
  }

  @override
  Future<double> checkBalance({
    required String accountId,
    required String upiPin,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final bank = _bankAccounts.firstWhere(
      (b) => b.id == accountId || b.bankName.toLowerCase().contains(accountId.toLowerCase()),
      orElse: () => _bankAccounts.first,
    );
    return bank.balance;
  }

  @override
  Future<List<UpiContactModel>> getRecentContacts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _contacts;
  }

  @override
  Future<PaymentModel> scanAndPay({
    required String qrData,
    required double amount,
    String? note,
    String? bankAccount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final txId = 'UPI/${DateTime.now().millisecondsSinceEpoch}/SCAN';
    final recipient = qrData.contains('@') ? qrData.split('@').first : 'Merchant QR';

    final payment = PaymentModel(
      id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      transactionId: txId,
      status: PaymentStatus.success,
      type: PaymentType.scanAndPay,
      recipientName: recipient,
      recipientUpiId: qrData.contains('@') ? qrData : 'merchant.upi@bank',
      bankAccount: bankAccount ?? 'Yes Bank (XX 3287)',
      note: note ?? 'Paid via QR Code',
      timestamp: DateTime.now(),
    );

    _payments[payment.id] = payment;
    return payment;
  }

  @override
  Future<PaymentModel> mobilePay({
    required String mobile,
    required double amount,
    String? recipientName,
    String? note,
    String? bankAccount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final txId = 'UPI/${DateTime.now().millisecondsSinceEpoch}/MOB';

    final payment = PaymentModel(
      id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      transactionId: txId,
      status: PaymentStatus.success,
      type: PaymentType.mobilePay,
      recipientName: recipientName ?? 'Contact ($mobile)',
      recipientUpiId: '$mobile@upi',
      bankAccount: bankAccount ?? 'Yes Bank (XX 3287)',
      note: note ?? 'Money Transfer',
      timestamp: DateTime.now(),
    );

    _payments[payment.id] = payment;
    return payment;
  }

  @override
  Future<PaymentModel> bankTransfer({
    required String accountNumber,
    required String ifsc,
    required double amount,
    String? accountHolderName,
    String? note,
    String? bankAccount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 850));
    final txId = 'UPI/${DateTime.now().millisecondsSinceEpoch}/IMPS';

    final payment = PaymentModel(
      id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      transactionId: txId,
      status: PaymentStatus.success,
      type: PaymentType.bankTransfer,
      recipientName: accountHolderName ?? 'Account Holder',
      recipientUpiId: 'A/C: $accountNumber ($ifsc)',
      bankAccount: bankAccount ?? 'Yes Bank (XX 3287)',
      note: note ?? 'Direct Bank Transfer',
      timestamp: DateTime.now(),
    );

    _payments[payment.id] = payment;
    return payment;
  }

  @override
  Future<PaymentModel> payBill({
    required String serviceTitle,
    required String consumerNumber,
    required double amount,
    String? operatorName,
    String? bankAccount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final txId = 'BBPS/${DateTime.now().millisecondsSinceEpoch}';

    final payment = PaymentModel(
      id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      transactionId: txId,
      status: PaymentStatus.success,
      type: PaymentType.billPayment,
      recipientName: operatorName ?? serviceTitle,
      recipientUpiId: 'Consumer ID: $consumerNumber',
      bankAccount: bankAccount ?? 'Yes Bank (XX 3287)',
      note: '$serviceTitle Payment',
      timestamp: DateTime.now(),
    );

    _payments[payment.id] = payment;
    return payment;
  }

  @override
  Future<PaymentModel> getPaymentStatus({required String paymentId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final payment = _payments[paymentId];
    if (payment != null) return payment;

    return PaymentModel(
      id: paymentId,
      amount: 100.0,
      transactionId: 'UPI/MOCK/STATUS',
      status: PaymentStatus.success,
      type: PaymentType.mobilePay,
      recipientName: 'Recipient',
      recipientUpiId: 'recipient@upi',
      bankAccount: 'Yes Bank (XX 3287)',
      note: 'Payment Successful',
      timestamp: DateTime.now(),
    );
  }
}
