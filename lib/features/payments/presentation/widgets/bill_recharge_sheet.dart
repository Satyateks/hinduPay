import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';
import 'amount_input.dart';
import 'upi_pin_sheet.dart';

class BillRechargeSheet extends StatefulWidget {
  final String serviceTitle;
  final String category;
  final String icon;

  const BillRechargeSheet({
    super.key,
    required this.serviceTitle,
    required this.category,
    required this.icon,
  });

  static void show(
    BuildContext context, {
    required String serviceTitle,
    required String category,
    required String icon,
    PaymentBloc? bloc,
  }) {
    PaymentBloc? paymentBloc = bloc;
    if (paymentBloc == null) {
      try {
        paymentBloc = BlocProvider.of<PaymentBloc>(context);
      } catch (_) {
        paymentBloc = null;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final content = BillRechargeSheet(
          serviceTitle: serviceTitle,
          category: category,icon: icon,
        );

        if (paymentBloc != null) {
          return BlocProvider<PaymentBloc>.value(
            value: paymentBloc,child: content,
          );
        }

        return BlocProvider<PaymentBloc>(
          create: (_) => getIt<PaymentBloc>(),
          child: content,
        );
      },
    );
  }

  @override
  State<BillRechargeSheet> createState() => _BillRechargeSheetState();
}

class _BillRechargeSheetState extends State<BillRechargeSheet> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _amountController = TextEditingController(text: '799');
  String? _selectedOperator;
  bool _billFetched = false;

  late final List<String> _operators;

  @override
  void initState() {
    super.initState();
    _operators = _getOperatorsForService(widget.serviceTitle);
    if (_operators.isNotEmpty) {
      _selectedOperator = _operators.first;
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  List<String> _getOperatorsForService(String service) {
    final lower = service.toLowerCase();
    if (lower.contains('mobile') || lower.contains('recharge')) {
      return ['Jio Prepaid', 'Airtel India', 'Vi (Vodafone Idea)', 'BSNL Mobile'];
    } else if (lower.contains('dth') || lower.contains('cable')) {
      return ['Tata Play (Tata Sky)', 'Airtel Digital TV', 'Dish TV', 'Sun Direct'];
    } else if (lower.contains('fastag')) {
      return ['SBI FASTag', 'ICICI Bank FASTag', 'Paytm Payments Bank', 'Axis Bank FASTag'];
    } else if (lower.contains('electric')) {
      return ['Tata Power - Delhi', 'BSES Rajdhani', 'UPPCL (Rural/Urban)', 'Adani Electricity Mumbai'];
    } else if (lower.contains('gas')) {
      return ['Indane Gas (IOCL)', 'Bharat Gas (BPCL)', 'HP Gas (HPCL)', 'Indraprastha Gas (IGL)'];
    } else if (lower.contains('water')) {
      return ['Delhi Jal Board (DJB)', 'Bangalore Water Supply (BWSSB)', 'Municipal Corp of Greater Mumbai'];
    } else if (lower.contains('broadband') || lower.contains('landline')) {
      return ['JioFiber', 'Airtel Xstream Fiber', 'ACT Fibernet', 'BSNL Broadband'];
    } else if (lower.contains('loan') || lower.contains('emi')) {
      return ['Bajaj Finance Ltd', 'HDFC Bank Loans', 'Hero Fincorp', 'Tata Capital'];
    } else if (lower.contains('credit')) {
      return ['HDFC Bank Credit Card', 'SBI Card', 'ICICI Bank Credit Card', 'Axis Bank Card'];
    } else if (lower.contains('lic') || lower.contains('insurance')) {
      return ['Life Insurance Corporation (LIC)', 'HDFC Life', 'ICICI Prudential Life', 'SBI Life'];
    }
    return ['Standard National Provider', 'State Board / Trust', 'Municipal Corporation'];
  }

  String _getIdLabel() {
    final lower = widget.serviceTitle.toLowerCase();
    if (lower.contains('mobile')) return 'Mobile Number';
    if (lower.contains('fastag')) return 'Vehicle Registration Number';
    if (lower.contains('dth')) return 'Subscriber / Smart Card ID';
    if (lower.contains('electric')) return 'Consumer CA Number';
    if (lower.contains('credit')) return 'Last 4 Digits of Card';
    if (lower.contains('loan')) return 'Loan Account Number';
    if (lower.contains('water') || lower.contains('gas')) return 'Customer / Consumer ID';
    return 'Account / Consumer Number';
  }

  Future<void> _handlePayment(BuildContext context) async {
    final amount = double.tryParse(_amountController.text) ?? 500;
    final consumerId = _idController.text.trim().isEmpty ? '9876543210' : _idController.text.trim();

    // Show UPI PIN Sheet
    final pinSuccess = await UpiPinSheet.show(
      context,
      title: 'ENTER UPI PIN',
      subtitle: 'To pay ₹${amount.toStringAsFixed(2)} for ${widget.serviceTitle}',
      amount: amount,
      bankName: 'Yes Bank',
      accountNumber: 'XX 3287',
      onPinSubmit: (pin) async {
        await Future.delayed(const Duration(milliseconds: 700));
        return true;
      },
    );

    if (pinSuccess == true && mounted) {
      context.read<PaymentBloc>().add(
        BillPaySubmitted(
          serviceTitle: widget.serviceTitle,
          consumerNumber: consumerId,
          amount: amount,
          operatorName: _selectedOperator,
          bankAccount: 'Yes Bank (XX 3287)',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    PaymentBloc? bloc;
    try {
      bloc = BlocProvider.of<PaymentBloc>(context);
    } catch (_) {
      bloc = null;
    }

    if (bloc == null) {
      return BlocProvider<PaymentBloc>(
        create: (_) => getIt<PaymentBloc>(),
        child: Builder(builder: (innerContext) => _buildSheetBody(innerContext)),
      );
    }

    return _buildSheetBody(context);
  }

  Widget _buildSheetBody(BuildContext context) {
    final idLabel = _getIdLabel();

    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state.status == PaymentBlocStatus.success && state.currentPayment != null) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          context.push('/upi/status', extra: state.currentPayment);
        } else if (state.status == PaymentBlocStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red,
              content: Text(state.errorMessage ?? 'Payment failed'),
            ),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFBFBFB),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(
          top: 14,left: 20,right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header Row
              Row(
                children: [
                  Container(width: 50,height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFECE5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      widget.icon,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.receipt_long_rounded,
                        color: Color(0xFFE65100),
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.serviceTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                        Text(
                          'BBPS & UPI Instant Bill Payment',
                          style: TextStyle(fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),

              const Divider(height: 30),

              // Operator / Provider dropdown
              const Text(
                'Select Operator / Biller',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedOperator,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    items: _operators.map((op) {
                      return DropdownMenuItem<String>(value: op,
                        child: Text(op,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedOperator = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ID Input Field
              Text(
                idLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                ),
                child: TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    hintText: 'Enter your $idLabel',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    border: InputBorder.none,
                    suffixIcon: !_billFetched
                        ? TextButton(
                            onPressed: () => setState(() => _billFetched = true),
                            child: const Text('Fetch Bill',
                              style: TextStyle(color: Color(0xFFFF6B00), 
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ) 
                        : const Icon(Icons.check_circle, color: Colors.green),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Amount Section
              const Text(
                'Bill / Recharge Amount',
                style: TextStyle(fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 8),
              AmountInput(controller: _amountController,quickAmounts: const [199, 499, 799, 1499, 2999]),

              const SizedBox(height: 24),

              // Pay Button with Loading state
              BlocBuilder<PaymentBloc, PaymentState>(
                builder: (context, state) {
                  final isLoading = state.status == PaymentBlocStatus.loading;
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => _handlePayment(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE65100),
                        foregroundColor: Colors.white,elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock_outline, size: 18),
                                const SizedBox(width: 8),
                                Text('Proceed to Pay ₹${_amountController.text}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
