import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';

class UpiPinPage extends StatelessWidget {
  final String? recipientName;
  final String? recipientPhone;
  final double? amount;
  final String? note;
  final String? bankName;
  final String? maskedAccount;

  const UpiPinPage({
    super.key,
    this.recipientName,
    this.recipientPhone,
    this.amount,
    this.note,
    this.bankName,
    this.maskedAccount,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PaymentBloc>(),
      child: _UpiPinView(
        recipientName: recipientName ?? 'Janice Wyman',
        recipientPhone: recipientPhone ?? '+91 70810 00705',
        amount: amount ?? 14000.0,
        note: note ?? 'Temple Seva',
        bankName: bankName ?? 'Yes Bank',
        maskedAccount: maskedAccount ?? 'XX 3297',
      ),
    );
  }
}

class _UpiPinView extends StatefulWidget {
  final String recipientName;
  final String recipientPhone;
  final double amount;
  final String note;
  final String bankName;
  final String maskedAccount;

  const _UpiPinView({
    required this.recipientName,
    required this.recipientPhone,
    required this.amount,
    required this.note,
    required this.bankName,
    required this.maskedAccount,
  });

  @override
  State<_UpiPinView> createState() => _UpiPinViewState();
}

class _UpiPinViewState extends State<_UpiPinView> {
  String _pin = '';
  final int _pinLength = 6;
  bool _isSubmitting = false;

  void _onKeyPress(String digit) {
    if (_isSubmitting) return;
    if (_pin.length < _pinLength) {
      HapticFeedback.lightImpact();
      setState(() => _pin += digit);
      if (_pin.length == _pinLength) {
        // Auto trigger submit after short delay for smoothness
        Future.delayed(const Duration(milliseconds: 300), _submitPayment);
      }
    }
  }

  void _onBackspace() {
    if (_isSubmitting) return;
    if (_pin.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  void _submitPayment() async {
    if (_isSubmitting) return;
    if (_pin.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your complete UPI PIN')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    HapticFeedback.mediumImpact();

    // Trigger PaymentBloc event
    context.read<PaymentBloc>().add(
      MobilePaySubmitted(
        mobile: widget.recipientPhone,
        amount: widget.amount,
        recipientName: widget.recipientName,
        note: widget.note,
        bankAccount: '${widget.bankName} (${widget.maskedAccount})',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state.status == PaymentBlocStatus.success && state.currentPayment != null) {
          context.pushReplacement('/upi/status', extra: state.currentPayment);
        } else if (state.status == PaymentBlocStatus.failure) {
          setState(() {
            _isSubmitting = false;
            _pin = '';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Payment failed. Please try again.'),
              backgroundColor: Colors.red[700],
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF212121), size: 19),
            onPressed: () => context.pop(),
          ),
          title: const Text('Sent to',
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // ----------------------------------------------------
              // RECIPIENT & AMOUNT HEADER ROW
              // ----------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Container(width: 44,height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFD9C2),
                      ),
                      child: Center(
                        child: Text(
                          widget.recipientName.isNotEmpty ? widget.recipientName[0] : 'J',
                          style: const TextStyle(
                            color: Color(0xFFE65100),
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.recipientName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.recipientPhone,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      '₹ ${widget.amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF212121),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

              // ----------------------------------------------------
              // ENTER UPI PIN & 6 CIRCULAR PIN DOTS
              // ----------------------------------------------------
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Enter UPI PIN',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF616161),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 6 Circular PIN dots matching reference mockup
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pinLength, (index) {
                        final isFilled = index < _pin.length;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 7),
                          width: 14,height: 14,
                          decoration: BoxDecoration(shape: BoxShape.circle,
                            color: isFilled ? const Color(0xFF212121) : Colors.transparent,
                            border: Border.all(width: 1.5,
                              color: isFilled ? const Color(0xFF212121) : const Color(0xFFBDBDBD),
                            ),
                          ),
                        );
                      }),
                    ),

                    if (_isSubmitting) ...[
                      const SizedBox(height: 24),
                      const SizedBox(
                        width: 24,height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5722)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ----------------------------------------------------
              // SOLID VIBRANT ORANGE "PAY NOW" BUTTON
              // ----------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5722), // Vibrant orange
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      _isSubmitting ? 'Processing...' : 'Pay Now',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ----------------------------------------------------
              // CUSTOM 12-KEY NUMERIC KEYPAD
              // ----------------------------------------------------
              Container(
                color: const Color(0xFFFAFAFA),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _keypadRow(['1', '2', '3'], ['', 'ABC', 'DEF']),
                    _keypadRow(['4', '5', '6'], ['GHI', 'JKL', 'MNO']),
                    _keypadRow(['7', '8', '9'], ['PQRS', 'TUV', 'WXYZ']),
                    _keypadBottomRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _keypadRow(List<String> digits, List<String> subs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (idx) {
          return _keypadButton(digits[idx], subs[idx]);
        }),
      ),
    );
  }

  Widget _keypadBottomRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Empty placeholder on left
          const SizedBox(width: 100, height: 52),

          // Zero (0)
          _keypadButton('0', ''),

          // Backspace (⌫)
          InkWell(
            onTap: _onBackspace,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 100,
              height: 52,
              alignment: Alignment.center,
              child: const Icon(Icons.backspace_outlined, size: 22, color: Color(0xFF212121)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _keypadButton(String digit, String sub) {
    return InkWell(
      onTap: () => _onKeyPress(digit),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        height: 52,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(digit,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF212121),
              ),
            ),
            if (sub.isNotEmpty)
              Text(sub,
                style: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9E9E9E),
                  letterSpacing: 0.5,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
