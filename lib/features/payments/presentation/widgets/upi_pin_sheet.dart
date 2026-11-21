import 'package:flutter/material.dart';

class UpiPinSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final double? amount;
  final String bankName;
  final String accountNumber;
  final Future<bool> Function(String pin) onPinSubmit;

  const UpiPinSheet({
    super.key,
    this.title = 'ENTER UPI PIN',
    this.subtitle = 'To authorize this transaction',
    this.amount,
    required this.bankName,
    required this.accountNumber,
    required this.onPinSubmit,
  });

  static Future<bool?> show(
    BuildContext context, {
    String title = 'ENTER UPI PIN',
    String subtitle = 'To authorize this transaction',
    double? amount,
    required String bankName,
    required String accountNumber,
    required Future<bool> Function(String pin) onPinSubmit,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UpiPinSheet(
        title: title,
        subtitle: subtitle,
        amount: amount,
        bankName: bankName,
        accountNumber: accountNumber,
        onPinSubmit: onPinSubmit,
      ),
    );
  }

  @override
  State<UpiPinSheet> createState() => _UpiPinSheetState();
}

class _UpiPinSheetState extends State<UpiPinSheet> {
  String _pin = '';
  static const int _pinLength = 4;
  bool _isLoading = false;
  String? _error;

  void _onKeyTap(String value) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += value;
        _error = null;
      });
      if (_pin.length == _pinLength) {
        _submitPin();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _error = null;
      });
    }
  }

  Future<void> _submitPin() async {
    if (_pin.length != _pinLength) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final success = await widget.onPinSubmit(_pin);
      if (!mounted) return;
      if (success) {
        Navigator.pop(context, true);
      } else {
        setState(() {
          _isLoading = false;
          _pin = '';
          _error = 'Incorrect UPI PIN. Please try again.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _pin = '';
        _error = 'Verification failed. Try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFBFBFB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            const SizedBox(height: 12),
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 14),

            // Bank and NPCI Security header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF003B73).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.bankName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003B73),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.accountNumber,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF757575),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.shield_outlined, size: 14, color: Colors.green[700]),
                      const SizedBox(width: 4),
                      Text(
                        'NPCI UPI SECURED',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 24),

            if (widget.amount != null) ...[
              Text(
                'Paying ₹${widget.amount!.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 4),
            ],

            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
            ),

            const SizedBox(height: 20),

            // PIN Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pinLength, (index) {
                final isFilled = index < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? const Color(0xFF1E1E1E) : Colors.transparent,
                    border: Border.all(
                      color: isFilled
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFF9E9E9E),
                      width: 2,
                    ),
                  ),
                );
              }),
            ),

            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            const SizedBox(height: 24),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(color: Color(0xFFFF6B00)),
              )
            else
              // Custom Numeric Keypad
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    _buildKeyRow(['1', '2', '3']),
                    _buildKeyRow(['4', '5', '6']),
                    _buildKeyRow(['7', '8', '9']),
                    _buildBottomKeyRow(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) => _buildKeyButton(key)).toList(),
      ),
    );
  }

  Widget _buildBottomKeyRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Backspace key
          Expanded(
            child: InkWell(
              onTap: _onBackspace,
              borderRadius: BorderRadius.circular(16),
              child: const SizedBox(
                height: 52,
                child: Center(
                  child: Icon(Icons.backspace_outlined, size: 22, color: Color(0xFF333333)),
                ),
              ),
            ),
          ),
          // '0' key
          _buildKeyButton('0'),
          // Submit key
          Expanded(
            child: InkWell(
              onTap: _submitPin,
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 52,
                child: Center(
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2E7D32),
                    ),
                    child: const Icon(Icons.check, size: 22, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyButton(String text) {
    return Expanded(
      child: InkWell(
        onTap: () => _onKeyTap(text),
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 52,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E1E1E),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
