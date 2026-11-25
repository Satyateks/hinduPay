import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/beneficiary.dart';

class BankTransferPage extends StatefulWidget {
  const BankTransferPage({super.key});

  @override
  State<BankTransferPage> createState() => _BankTransferPageState();
}

class _BankTransferPageState extends State<BankTransferPage> {
  final List<Beneficiary> _beneficiaries = [
    const Beneficiary(
      id: 'ben_1',
      name: 'Rohit Khatri',
      bankName: 'Axis Bank',
      accountNumberMasked: '**4398',
      accountNumber: '918237464398',
      ifsc: 'UTIB0000123',
      brandColor: 0xFF97144D, // Axis Maroon
    ),
    const Beneficiary(
      id: 'ben_2',
      name: 'Sakshi Jain',
      bankName: 'State Bank of India',
      accountNumberMasked: '**0215',
      accountNumber: '918237460215',
      ifsc: 'SBIN0001234',
      brandColor: 0xFF003366, // SBI Blue
    ),
    const Beneficiary(
      id: 'ben_3',
      name: 'Anil Kumar',
      bankName: 'Yes Bank',
      accountNumberMasked: '**3297',
      accountNumber: '918237463297',
      ifsc: 'YESB0000001',
      brandColor: 0xFF003399, // Yes Bank Blue
    ),
  ];

  void _onBeneficiaryTap(Beneficiary ben) {
    context.push(
      '/upi/pay',
      extra: {
        'name': ben.name,
        'phone': '${ben.bankName} (${ben.accountNumberMasked})',
        'amount': 14000.0,
      },
    );
  }

  void _navigateToAddBeneficiary() async {
    final result = await context.push<Beneficiary>('/upi/bank/add');
    if (result != null && mounted) {
      setState(() {
        _beneficiaries.insert(0, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDF9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF212121), size: 19),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Bank Transfer',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _beneficiaries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final ben = _beneficiaries[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _onBeneficiaryTap(ben),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            // Bank Initial Circle
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(ben.brandColor),
                              ),
                              child: Center(
                                child: Text(
                                  ben.bankName.isNotEmpty ? ben.bankName[0] : 'B',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Name & Bank Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ben.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${ben.bankName} - ${ben.accountNumberMasked}',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: Color(0xFF9E9E9E),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: Color(0xFFBDBDBD),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ----------------------------------------------------
          // BOTTOM ORANGE BUTTON: + Add Beneficiary
          // ----------------------------------------------------
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _navigateToAddBeneficiary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722), // Vibrant orange
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  '+ Add Beneficiary',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
