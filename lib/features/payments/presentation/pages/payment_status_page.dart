import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/payment.dart';
import '../widgets/upi_pin_sheet.dart';

class PaymentStatusPage extends StatelessWidget {
  final Payment? payment;

  const PaymentStatusPage({super.key, this.payment});

  @override
  Widget build(BuildContext context) {
    final pay = payment ??
        Payment(
          id: 'pay_demo',
          amount: 500,
          transactionId: 'UPI/382910482910/SUCCESS',
          status: PaymentStatus.success,
          recipientName: 'Shri Ram Mandir Trust',
          recipientUpiId: 'shriram.mandir@upi',
          bankAccount: 'Yes Bank (XX 3287)',
          note: 'Temple Daan & Seva',
          timestamp: DateTime.now(),
        );

    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(pay.timestamp);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Success Icon badge with glowing ring
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE8F5E9),
                        border: Border.all(color: const Color(0xFF81C784), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF2E7D32),
                          size: 60,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    const Text(
                      'Payment Successful',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 12.5, color: Color(0xFF757575)),
                    ),

                    const SizedBox(height: 20),

                    // Amount Text
                    Text(
                      '₹${pay.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1E1E),
                        letterSpacing: -1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Recipient Name
                    Text(
                      'Paid to ${pay.recipientName ?? "Beneficiary"}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF424242),
                      ),
                    ),
                    if (pay.recipientUpiId != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        pay.recipientUpiId!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),

                    // Receipt Details Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            'UPI Ref No.',
                            pay.transactionId ?? 'UPI/839102840192',
                          ),
                          const Divider(height: 22),
                          _buildDetailRow(
                            'Debited From',
                            pay.bankAccount ?? 'Yes Bank (XX 3287)',
                          ),
                          if (pay.note != null && pay.note!.isNotEmpty) ...[
                            const Divider(height: 22),
                            _buildDetailRow('Remark / Note', pay.note!),
                          ],
                          const Divider(height: 22),
                          _buildDetailRow('Status', 'SUCCESS', isSuccess: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // NPCI / BHIM UPI assurance badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_rounded, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(
                          'Powered by Unified Payments Interface (UPI)',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            UpiPinSheet.show(
                              context,
                              title: 'CHECK BALANCE',
                              bankName: 'Yes Bank',
                              accountNumber: 'XX 3287',
                              onPinSubmit: (pin) async {
                                await Future.delayed(const Duration(milliseconds: 600));
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Available Balance: ₹48,250.75'),
                                      backgroundColor: Color(0xFF2E7D32),
                                    ),
                                  );
                                }
                                return true;
                              },
                            );
                          },
                          icon: const Icon(Icons.account_balance_wallet_outlined, size: 18),
                          label: const Text('Check Balance'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFE65100),
                            side: const BorderSide(color: Color(0xFFFFCCAA)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Payment receipt saved & shared!')),
                            );
                          },
                          icon: const Icon(Icons.share_outlined, size: 18),
                          label: const Text('Share Receipt'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1E1E1E),
                            side: BorderSide(color: Colors.grey[300]!),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => context.go('/main/upi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE65100),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 1,
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isSuccess = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF757575),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSuccess ? const Color(0xFF2E7D32) : const Color(0xFF1E1E1E),
          ),
        ),
      ],
    );
  }
}
