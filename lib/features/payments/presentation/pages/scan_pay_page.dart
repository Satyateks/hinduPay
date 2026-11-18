import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/di/injection.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';
import '../widgets/amount_input.dart';
import '../widgets/upi_pin_sheet.dart';

/// Parsed UPI QR Code payload data
class UpiQrData {
  final String upiId;
  final String payeeName;
  final double? amount;
  final String? note;
  final String rawData;

  const UpiQrData({
    required this.upiId,
    required this.payeeName,
    this.amount,
    this.note,
    required this.rawData,
  });

  factory UpiQrData.parse(String raw) {
    final clean = raw.trim();
    if (clean.toLowerCase().startsWith('upi://pay') || clean.contains('pa=')) {
      try {
        final uri = Uri.parse(clean);
        final params = uri.queryParameters;
        final pa = params['pa'] ?? '';
        final pn = params['pn'] != null ? Uri.decodeComponent(params['pn']!) : '';
        final am = params['am'] != null ? double.tryParse(params['am']!) : null;
        final tn = params['tn'] != null ? Uri.decodeComponent(params['tn']!) : null;

        String displayName = pn;
        if (displayName.isEmpty && pa.isNotEmpty) {
          displayName = pa.split('@').first.replaceAll('.', ' ').replaceAll('_', ' ');
          displayName = displayName.split(' ').map((s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '').join(' ');
        }

        return UpiQrData(
          upiId: pa.isNotEmpty ? pa : clean,
          payeeName: displayName.isNotEmpty ? displayName : 'Verified Merchant',
          amount: am,note: tn,
          rawData: clean,
        );
      } catch (_) {}
    }

    if (clean.contains('@')) {
      final name = clean.split('@').first.replaceAll('.', ' ').replaceAll('_', ' ');
      final titleName = name.split(' ').map((s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '').join(' ');
      return UpiQrData(
        upiId: clean,rawData: clean,
        payeeName: titleName.isNotEmpty ? titleName : 'Verified Payee',
      );
    }

    return UpiQrData(
      upiId: clean,
      payeeName: 'Verified Payee',
      rawData: clean,
    );
  }
}

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

class _ScanPayViewState extends State<_ScanPayView>
    with SingleTickerProviderStateMixin {
  late final MobileScannerController cameraController;
  late final AnimationController _animController;
  late final Animation<double> _scanAnimation;

  bool _isTorchOn = false;
  bool _isProcessing = false;
  bool _hasDetected = false;
  
  final TextEditingController _upiIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animController);
  }

  @override
  void dispose() {
    cameraController.dispose();
    _animController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  Future<void> _toggleTorch() async {
    try {
      await cameraController.toggleTorch();
      setState(() => _isTorchOn = !_isTorchOn);
    } catch (e) {
      debugPrint('Torch toggle error: $e');
    }
  }

  Future<void> _switchCamera() async {
    try {
      await cameraController.switchCamera();
    } catch (e) {
      debugPrint('Switch camera error: $e');
    }
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (_isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final first = barcodes.first;
    final rawValue = first.rawValue ?? first.displayValue;
    if (rawValue == null || rawValue.trim().isEmpty) return;

    final parsedData = UpiQrData.parse(rawValue);
    _handleDetectedData(parsedData);
  }

  void _handleDetectedData(UpiQrData upiData) {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _hasDetected = true;
    });

    HapticFeedback.mediumImpact();
    _showPaymentModal(context, upiData);
  }

  void _showPaymentModal(BuildContext context, UpiQrData data) async {
    final amountController = TextEditingController(text: data.amount != null ? data.amount!.toStringAsFixed(0) : '500');
    final noteController = TextEditingController(text: data.note ?? 'Temple Seva');
    String selectedBank = 'Yes Bank (XX 3287)';

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 14,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
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

                    // Payee Info Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFFD9C2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFFFF7043), Color(0xFFD84315)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Center(child: Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 26)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        data.payeeName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF1E1E1E),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified, color: Color(0xFF2E7D32), size: 16),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  data.upiId,
                                  style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Amount Input
                    const Text(
                      'Enter Amount',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AmountInput(controller: amountController),

                    const SizedBox(height: 16),

                    // Note / Remarks
                    const Text(
                      'Add a Note',
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
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: noteController,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Mandir Seva, Daan, Dakshina',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Debit Bank Selector
                    const Text(
                      'Pay From Account',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setModalState(() => selectedBank = 'Yes Bank (XX 3287)'),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: selectedBank.contains('Yes')? const Color(0xFFFFF3EC): Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedBank.contains('Yes') ? const Color(0xFFFF6B00): Colors.grey[300]!,
                                  width: selectedBank.contains('Yes') ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF003B73),
                                    ),
                                    child: const Center(
                                      child: Text('Y',
                                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Yes Bank', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                        Text('XX 3287', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => setModalState(() => selectedBank = 'Axis Bank (XX 4398)'),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: selectedBank.contains('Axis')
                                    ? const Color(0xFFFFF3EC)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedBank.contains('Axis')
                                      ? const Color(0xFFFF6B00)
                                      : Colors.grey[300]!,
                                  width: selectedBank.contains('Axis') ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF97144D),
                                    ),
                                    child: const Center(
                                      child: Text('A',style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Axis Bank', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                        Text('XX 4398', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Proceed Button
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
                            subtitle: 'To pay ₹$amount to ${data.payeeName}',
                            amount: amount,
                            bankName: selectedBank.contains('Yes') ? 'Yes Bank' : 'Axis Bank',
                            accountNumber: selectedBank.contains('Yes') ? 'XX 3287' : 'XX 4398',
                            onPinSubmit: (pin) async {
                              await Future.delayed(const Duration(milliseconds: 650));
                              return true;
                            },
                          );

                          if (pinSuccess == true && context.mounted) {
                            context.read<PaymentBloc>().add(
                              ScanAndPaySubmitted(
                                qrData: data.upiId,
                                amount: amount,
                                note: noteController.text,
                                bankAccount: selectedBank,
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
                          elevation: 2,
                        ),
                        child: Text(
                          'Proceed to Pay ₹${amountController.text}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    // Reset processing state when bottom sheet closes
    if (mounted) {
      setState(() {
        _isProcessing = false;
        _hasDetected = false;
      });
    }
  }

  void _showGalleryOrDemoSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
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
            const Text(
              'Quick Pay & Test QR Codes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E1E1E)),
            ),
            const SizedBox(height: 4),
            Text(
              'Select a temple or test QR code to simulate a scan',
              style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            _buildDemoQrTile(
              title: 'Shri Ram Mandir Trust',
              subtitle: 'shriram.mandir.trust@yesbank',
              amount: 500,
              icon: Icons.temple_hindu,
              color: const Color(0xFFFF6B00),
              onTap: () {
                Navigator.pop(sheetContext);
                _handleDetectedData(
                  UpiQrData(
                    upiId: 'shriram.mandir.trust@yesbank',
                    payeeName: 'Shri Ram Mandir Trust',
                    amount: 500,
                    note: 'Temple Seva & Daan',
                    rawData: 'shriram.mandir.trust@yesbank',
                  ),
                );
              },
            ),
            _buildDemoQrTile(
              title: 'Kashi Vishwanath Mandir',
              subtitle: 'kashivishwanath@sbi',
              amount: 250,
              icon: Icons.brightness_high,
              color: const Color(0xFFE5094C),
              onTap: () {
                Navigator.pop(sheetContext);
                _handleDetectedData(
                  UpiQrData(
                    upiId: 'kashivishwanath@sbi',
                    payeeName: 'Kashi Vishwanath Mandir',
                    amount: 250,
                    note: 'Ganga Aarti Seva',
                    rawData: 'kashivishwanath@sbi',
                  ),
                );
              },
            ),
            _buildDemoQrTile(
              title: 'Pandit Rajesh Sharma',
              subtitle: 'rajesh.pandit@ybl',
              amount: 1100,
              icon: Icons.person_outline,
              color: const Color(0xFF1E88E5),
              onTap: () {
                Navigator.pop(sheetContext);
                _handleDetectedData(
                  UpiQrData(
                    upiId: 'rajesh.pandit@ybl',
                    payeeName: 'Pandit Rajesh Sharma',
                    amount: 1100,
                    note: 'Pooja Dakshina',
                    rawData: 'rajesh.pandit@ybl',
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(sheetContext);
                _showManualUpiDialog();
              },
              icon: const Icon(Icons.edit_note_rounded, size: 20),
              label: const Text('Enter UPI ID / Mobile Number'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE65100),
                side: const BorderSide(color: Color(0xFFFFCCAA)),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoQrTile({
    required String title,
    required String subtitle,
    required double amount,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.15),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    Text(subtitle, style: TextStyle(fontSize: 11.5, color: Colors.grey[600])),
                  ],
                ),
              ),
              Text('₹${amount.toInt()}',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFFE65100)),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showManualUpiDialog() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Enter UPI ID / Phone Number', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: TextField(
          controller: _upiIdController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'e.g. pujariji@upi or 9876543210@ybl',
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final id = _upiIdController.text.trim();
              Navigator.pop(dialogCtx);
              if (id.isNotEmpty) _handleDetectedData(UpiQrData.parse(id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE65100),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
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
                          onPressed: _toggleTorch,
                        ),
                        IconButton(
                          icon: const Icon(Icons.flip_camera_ios_outlined, color: Colors.white),
                          onPressed: _switchCamera,
                        ),
                        IconButton(
                          icon: const Icon(Icons.photo_library_outlined, color: Colors.white),
                          onPressed: _showGalleryOrDemoSheet,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              const Text(
                'Align QR code inside the box to pay',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),

              // Scanner Viewfinder Area
              Expanded(
                child: Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: _hasDetected ? const Color(0xFF00C853): const Color(0xFFFF6B00),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_hasDetected ? const Color(0xFF00C853) : const Color(0xFFFF6B00)).withValues(alpha: 0.35),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Live Camera Scanner
                          MobileScanner(
                            controller: cameraController,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error) {
                              return Container(
                                color: const Color(0xFF1E1E1E),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.videocam_off_outlined,color: Colors.white54,size: 46),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Camera Not Available',
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Use the simulate button below to test scanner',
                                      textAlign: TextAlign.center,style: TextStyle(color: Colors.white60,fontSize: 11),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDetect: _onBarcodeDetected,
                          ),

                          // 4 Corner brackets
                          _CornerBrackets(color: _hasDetected ? const Color(0xFF00C853) : const Color(0xFFFF6B00)),

                          // Animated Scan Laser Line
                          if (!_hasDetected)
                            AnimatedBuilder(
                              animation: _scanAnimation,
                              builder: (context, child) {
                                return Positioned(
                                  top: _scanAnimation.value * 260,
                                  left: 12,
                                  right: 12,
                                  child: Container(
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6B00),
                                      borderRadius: BorderRadius.circular(2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF6B00)
                                              .withValues(alpha: 0.85),
                                          blurRadius: 12,
                                          spreadRadius: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                          // Subtle watermark icon
                          if (!_hasDetected)
                            Icon(
                              Icons.qr_code_2_rounded,
                              size: 110,
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Section: Manual Enter UPI ID / Demo QR trigger
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF181818),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Simulate Scan button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _handleDetectedData(
                            UpiQrData(
                              upiId: 'shriram.mandir.trust@yesbank',
                              payeeName: 'Shri Ram Mandir Trust',
                              amount: 500,
                              note: 'Temple Seva & Daan',
                              rawData: 'upi://pay?pa=shriram.mandir.trust@yesbank&pn=Shri%20Ram%20Mandir%20Trust&am=500&tn=Temple%20Seva%20Daan',
                            ),
                          );
                        },
                        icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
                        label: const Text(
                          'Simulate Scan Mandir QR',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B00),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Manual UPI ID button
                    InkWell(
                      onTap: _showManualUpiDialog,
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit_note, color: Colors.white70, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Or enter UPI ID / Mobile Number manually',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
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

/// 4 Corner Brackets for Scanner viewfinder
class _CornerBrackets extends StatelessWidget {
  final Color color;
  const _CornerBrackets({required this.color});

  @override
  Widget build(BuildContext context) {
    const size = 32.0;
    const thickness = 4.0;
    const radius = 12.0;

    return Stack(
      children: [
        // Top-left
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: color, width: thickness),
                left: BorderSide(color: color, width: thickness),
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(radius),
              ),
            ),
          ),
        ),
        // Top-right
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: color, width: thickness),
                right: BorderSide(color: color, width: thickness),
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(radius),
              ),
            ),
          ),
        ),
        // Bottom-left
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: color, width: thickness),
                left: BorderSide(color: color, width: thickness),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(radius),
              ),
            ),
          ),
        ),
        // Bottom-right
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: color, width: thickness),
                right: BorderSide(color: color, width: thickness),
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(radius),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
