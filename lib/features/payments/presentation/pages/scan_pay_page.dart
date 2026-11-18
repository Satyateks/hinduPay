import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/di/injection.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';
import '../widgets/amount_input.dart';
import '../widgets/upi_pin_sheet.dart';

class ScanPayPage extends StatelessWidget {
  const ScanPayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PaymentBloc>()..add(const LoadUpiDashboard()),
      child: const _ScanPayView(),
    );
  }
}

class _ScanPayView extends StatefulWidget {
  const _ScanPayView();

  @override
  State<_ScanPayView> createState() => _ScanPayViewState();
}

class _ScanPayViewState extends State<_ScanPayView> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scanAnimation;
  bool _isTorchOn = false;
  final TextEditingController _upiIdController = TextEditingController();
  final MobileScannerController cameraController = MobileScannerController();
 


  
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  void _showPaymentModal(BuildContext context, String scannedId) {
    final amountController = TextEditingController(text: '500');
    final noteController = TextEditingController(text: 'Temple Seva');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF6B00).withValues(alpha: 0.12),
                    ),
                    child: const Icon(Icons.qr_code, color: Color(0xFFFF6B00)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Paying to Verified UPI QR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                        Text(
                          scannedId,
                          style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 28),
              const Text(
                'Enter Amount',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              AmountInput(controller: amountController),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    hintText: 'Add a note (e.g. Mandir Seva, Daan)',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    final amount = double.tryParse(amountController.text) ?? 500;
                    Navigator.pop(sheetContext);

                    final pinSuccess = await UpiPinSheet.show(
                      context,
                      title: 'ENTER UPI PIN',
                      subtitle: 'To pay ₹$amount to $scannedId',
                      amount: amount,
                      bankName: 'Yes Bank',
                      accountNumber: 'XX 3287',
                      onPinSubmit: (pin) async {
                        await Future.delayed(const Duration(milliseconds: 650));
                        return true;
                      },
                    );

                    if (pinSuccess == true && context.mounted) {
                      context.read<PaymentBloc>().add(
                        ScanAndPaySubmitted(
                          qrData: scannedId,
                          amount: amount,
                          note: noteController.text,
                          bankAccount: 'Yes Bank (XX 3287)',
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE65100),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Pay',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state.status == PaymentBlocStatus.success && state.currentPayment != null) {
          context.pushReplacement('/upi/status', extra: state.currentPayment);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    const Text(
                      'Scan & Pay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isTorchOn ? Icons.flash_on : Icons.flash_off,
                            color: _isTorchOn ? Colors.amber : Colors.white,
                          ),
                          onPressed: () async {
                            await cameraController.toggleTorch();
                            setState(() => _isTorchOn = !_isTorchOn);
                          },
                         ),
                        IconButton(
                          icon: const Icon(Icons.photo_library_outlined, color: Colors.white),
                          onPressed: () => _showPaymentModal(context, 'gallery_scanned@upi'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Align QR code within the frame',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Scanner Viewfinder Area
              Expanded(
                child: Center(
                  child: Container(
                    width: 270,
                    height: 270,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFFF6B00), width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          MobileScanner(
                            controller: cameraController,
                            onDetect: (capture) {
                              final List<Barcode> barcodes = capture.barcodes;
                              for (final barcode in barcodes) {
                                debugPrint('Barcode found! ${barcode.rawValue}');
                              }
                            },
                          ),
                          // Corner brackets
                          const Positioned(
                            top: 10,
                            left: 10,
                            child: Icon(Icons.crop_free, color: Colors.white38, size: 40),
                          ),
                          // Animated scan line
                          AnimatedBuilder(
                            animation: _scanAnimation,
                            builder: (context, child) {
                              return Positioned(
                                top: _scanAnimation.value * 250,
                                left: 16,
                                right: 16,
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6B00),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF6B00).withValues(alpha: 0.8),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          // Center QR icon
                          Icon(
                            Icons.qr_code_2_rounded,
                            size: 130,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Section: Manual Enter UPI ID / Demo QR trigger
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Demo Scan button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => _showPaymentModal(
                          context,
                          'shriram.mandir.trust@yesbank',
                        ),
                        icon: const Icon(Icons.camera_alt_outlined, size: 20),
                        label: const Text(
                          'Simulate Scan Mandir QR',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B00),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Enter UPI ID option
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (dialogCtx) => AlertDialog(
                            title: const Text('Enter UPI ID / VPA'),
                            content: TextField(
                              controller: _upiIdController,
                              decoration: const InputDecoration(
                                hintText: 'e.g. pujariji@upi',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogCtx),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final id = _upiIdController.text.trim();
                                  Navigator.pop(dialogCtx);
                                  if (id.isNotEmpty) _showPaymentModal(context, id);
                                },
                                child: const Text('Continue'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Or enter UPI ID / Phone Number manually',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}
