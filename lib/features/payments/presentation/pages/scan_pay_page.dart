import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/di/injection.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';

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
        final pn = params['pn'] != null
            ? Uri.decodeComponent(params['pn']!)
            : '';
        final am = params['am'] != null ? double.tryParse(params['am']!) : null;
        final tn = params['tn'] != null
            ? Uri.decodeComponent(params['tn']!)
            : null;

        String displayName = pn;
        if (displayName.isEmpty && pa.isNotEmpty) {
          displayName = pa
              .split('@')
              .first
              .replaceAll('.', ' ')
              .replaceAll('_', ' ');
          displayName = displayName
              .split(' ')
              .map(
                (s) => s.isNotEmpty
                    ? '${s[0].toUpperCase()}${s.substring(1)}'
                    : '',
              )
              .join(' ');
        }

        return UpiQrData(
          upiId: pa.isNotEmpty ? pa : clean,
          payeeName: displayName.isNotEmpty ? displayName : 'Verified Merchant',
          amount: am,
          note: tn,
          rawData: clean,
        );
      } catch (_) {}
    }

    if (clean.contains('@')) {
      final name = clean
          .split('@')
          .first
          .replaceAll('.', ' ')
          .replaceAll('_', ' ');
      final titleName = name
          .split(' ')
          .map(
            (s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '',
          )
          .join(' ');
      return UpiQrData(
        upiId: clean,
        rawData: clean,
        payeeName: titleName.isNotEmpty ? titleName : 'Verified Payee',
      );
    }

    return UpiQrData(upiId: clean, payeeName: 'Verified Payee', rawData: clean);
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
  // ignore: unused_field
  bool _hasDetected = false;

  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _recentContacts = const [
    {
      'name': 'Sonal',
      'phone': '+91 98112 34567',
      'avatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      'color': Color(0xFFFF8A65),
    },
    {
      'name': 'Sumit',
      'phone': '+91 98765 43210',
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'color': Color(0xFF4DB6AC),
    },
    {
      'name': 'Harshit',
      'phone': '+91 98123 45678',
      'avatar':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      'color': Color(0xFF7986CB),
    },
    {
      'name': 'Ansh',
      'phone': '+91 98987 65432',
      'avatar':
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      'color': Color(0xFFFFB74D),
    },
    {
      'name': 'Radhika',
      'phone': '+91 98234 56789',
      'avatar':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      'color': Color(0xFFBA68C8),
    },
  ];

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
    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animController);
  }

  @override
  void dispose() {
    cameraController.dispose();
    _animController.dispose();
    _searchController.dispose();
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

    // Directly navigate to SendMoneyPage (Screen 7) with the parsed QR information
    context
        .push(
          '/upi/pay',
          extra: {
            'name': upiData.payeeName,
            'phone': upiData.upiId,
            'amount': upiData.amount ?? 14000.0,
            'note': upiData.note ?? 'Temple Seva',
          },
        )
        .then((_) {
          if (mounted)
            setState(() {
              _isProcessing = false;
              _hasDetected = false;
            });
        });
  }

  void _showSimulateDialog() {
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
              'Select Demo Payee / Scan Simulation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 14),
            _demoTile(
              name: 'Shri Ram Mandir Trust',
              upiId: 'shriram.mandir@yesbank',
              amount: 501,
              icon: Icons.temple_hindu_rounded,
              color: const Color(0xFFFF6B00),
            ),
            _demoTile(
              name: 'Janice Wyman',
              upiId: '+91 70810 00705',
              amount: 14000,
              icon: Icons.person_rounded,
              color: const Color(0xFF97144D),
            ),
            _demoTile(
              name: 'Rohan Kumar',
              upiId: '+91 70826 60755',
              amount: 14000,
              icon: Icons.person_outline_rounded,
              color: const Color(0xFF1E88E5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _demoTile({
    required String name,
    required String upiId,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        _handleDetectedData(
          UpiQrData(
            upiId: upiId,
            payeeName: name,
            amount: amount,
            note: 'Payment to $name',
            rawData: upiId,
          ),
        );
      },
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(icon, color: color),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(
        upiId,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: Text(
        '₹${amount.toStringAsFixed(0)}',
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 15,
          color: Color(0xFFE65100),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ----------------------------------------------------
            // TOP BAR: < SCAN ANY UPI QR [Flash]
            // ----------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black87,
                      size: 20,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  const Text(
                    'SCAN ANY UPI QR',
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isTorchOn
                          ? Icons.flash_on_rounded
                          : Icons.flash_off_rounded,
                      color: _isTorchOn
                          ? const Color(0xFFFF6B00)
                          : Colors.black87,
                      size: 22,
                    ),
                    onPressed: _toggleTorch,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ----------------------------------------------------
            // VIEWFINDER BOX WITH ORANGE ROUNDED CORNERS
            // ----------------------------------------------------
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 270,height: 270,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Stack(
                      children: [
                        // Live Scanner Preview
                        ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: MobileScanner(
                            controller: cameraController,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error) {
                              return Container(
                                color: const Color(0xFFEEEEEE),
                                child: Center(
                                  child: Icon(
                                    Icons.qr_code_2_rounded,
                                    size: 110,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              );
                            },
                            onDetect: _onBarcodeDetected,
                          ),
                        ),

                        // Corner Brackets with bold orange rounded corners
                        const _BoldCornerBrackets(color: Color(0xFFFF6B00)),

                        // Scanning Laser Line
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
                                  borderRadius: BorderRadius.circular(2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFF6B00,
                                      ).withValues(alpha: 0.8),
                                      blurRadius: 10,
                                      spreadRadius: 2,
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

                  const SizedBox(height: 20),

                  // ----------------------------------------------------
                  // BHIM UPI LOGO ROW & ACTIONS
                  // ----------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _showSimulateDialog,
                        icon: const Icon(
                          Icons.photo_library_outlined,
                          color: Color(0xFF616161),
                          size: 24,
                        ),
                        tooltip: 'Upload QR from gallery',
                      ),
                      const SizedBox(width: 16),
                      // BHIM UPI branding badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'BHIM ',
                                    style: TextStyle(
                                      color: Color(0xFF1E88E5),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'UPI ',
                                    style: TextStyle(
                                      color: Color(0xFF2E7D32),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Iconic dual arrows
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 10,
                              color: Color(0xFFFF6B00),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 10,
                              color: Color(0xFF2E7D32),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: _toggleTorch,
                        icon: Icon(
                          _isTorchOn
                              ? Icons.flashlight_on_rounded
                              : Icons.flashlight_off_rounded,
                          color: _isTorchOn
                              ? const Color(0xFFFF6B00)
                              : const Color(0xFF616161),
                          size: 24,
                        ),
                        tooltip: 'Toggle Flashlight',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ----------------------------------------------------
            // BOTTOM SHEET: RECENT CONTACTS
            // ----------------------------------------------------
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Center(
                    child: Text(
                      'Recent Contacts',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF616161),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Search Bar with search icon and mic
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: Color(0xFF9E9E9E),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(fontSize: 13.5),
                            decoration: const InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(
                                color: Color(0xFFBDBDBD),
                                fontSize: 13.5,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onSubmitted: (query) {
                              if (query.trim().isNotEmpty) {
                                context.push(
                                  '/upi/pay',
                                  extra: {
                                    'name': query.trim(),
                                    'phone': query.trim(),
                                    'amount': 14000.0,
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        const Icon(
                          Icons.mic_none_outlined,
                          color: Color(0xFF757575),
                          size: 20,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Horizontal Recent Contacts Avatar List
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _recentContacts.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final contact = _recentContacts[index];
                        final name = contact['name'] as String;
                        final phone = contact['phone'] as String;
                        final color = contact['color'] as Color;

                        return InkWell(
                          onTap: () {
                            context.push(
                              '/upi/pay',
                              extra: {
                                'name': name,
                                'phone': phone,
                                'amount': 14000.0,
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: SizedBox(
                            width: 60,
                            child: Column(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: color,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.35),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      name.isNotEmpty ? name[0] : 'U',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF212121),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
}

/// 4 Corner Brackets for Scanner Viewfinder matching Screen 2
class _BoldCornerBrackets extends StatelessWidget {
  final Color color;
  const _BoldCornerBrackets({required this.color});

  @override
  Widget build(BuildContext context) {
    const size = 36.0;
    const thickness = 4.5;
    const radius = 24.0;

    return Stack(
      children: [
        // Top-left
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(radius),
              ),
              border: Border(
                top: BorderSide(color: color, width: thickness),
                left: BorderSide(color: color, width: thickness),
              ),
            ),
          ),
        ),

        // Top-right
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(radius),
              ),
              border: Border(
                top: BorderSide(color: color, width: thickness),
                right: BorderSide(color: color, width: thickness),
              ),
            ),
          ),
        ),

        // Bottom-left
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(radius),
              ),
              border: Border(
                bottom: BorderSide(color: color, width: thickness),
                left: BorderSide(color: color, width: thickness),
              ),
            ),
          ),
        ),

        // Bottom-right
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(radius),
              ),
              border: Border(
                bottom: BorderSide(color: color, width: thickness),
                right: BorderSide(color: color, width: thickness),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
