import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../../core/di/injection.dart';
import '../../../../core/widgets/app_img.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';
import '../widgets/bill_recharge_sheet.dart';
import '../widgets/offers_rewards_sheet.dart';
import '../widgets/upi_pin_sheet.dart';
import '../widgets/upi_service_icon.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PaymentBloc>()..add(const LoadUpiDashboard()),
      child: const _PaymentsPageView(),
    );
  }
}

class _PaymentsPageView extends StatefulWidget {
  const _PaymentsPageView();

  @override
  State<_PaymentsPageView> createState() => _PaymentsPageViewState();
}

class _PaymentsPageViewState extends State<_PaymentsPageView> {
  final TextEditingController _searchController = TextEditingController();
  
  late stt.SpeechToText _speech;
  bool _isListening = false;
  
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    await _speech.initialize(
      onStatus: (status) {if (mounted) setState(() {_isListening = _speech.isListening;});},
      onError: (error) {debugPrint('Speech error: $error');},
    );
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_speech.isListening) {
      await _speech.stop();
      return;
    }

    bool available = await _speech.initialize();
    if (!available) return;
    await _speech.listen(
      localeId: 'en_IN',
      onResult: (result) {
        setState(() {
          _searchController.value = TextEditingValue(
            text: result.recognizedWords,
            selection: TextSelection.collapsed(offset: result.recognizedWords.length),
          );
        });
      },
    );
    // await _speech.listen(
    //   localeId: 'en_IN',
    //   onResult: (result) {
    //     setState(() {
    //       _searchController.text = result.recognizedWords;
    //       _searchController.selection = TextSelection.collapsed(offset: _searchController.text.length);
    //     });
    //   },
    // );
  }

  void _handleViewBalance(
    BuildContext context,
    String accountId,
    String bankName,
    String accountNumber,
  ) async {
    final success = await UpiPinSheet.show(
      context,
      title: 'ENTER UPI PIN',
      subtitle: 'To fetch available bank balance',
      bankName: bankName,
      accountNumber: accountNumber,
      onPinSubmit: (pin) async {
        context.read<PaymentBloc>().add(
          CheckBalanceRequested(accountId: accountId, upiPin: pin),
        );
        await Future.delayed(const Duration(milliseconds: 650));
        return true;
      },
    );

    if (success == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Balance updated for $bankName ($accountNumber)'),
          backgroundColor: const Color(0xFF2E7D32),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.15, 0.4, 1.0],
            // colors: [Color(0xFFFFEDE1), // Subtle warm peach tint at the top
            //   Color(0xFFFFF7F0),Color(0xFFFFFDFB),Color(0xFFFFFDF9)],
             colors: [Color(0xFFF36B21),Color(0xFFF58344),Color(0xFFFFF8EF),Color(0xFFFFFDF9)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ----------------------------------------------------
              // 1. TOP SEARCH & PROFILE BAR
              // ----------------------------------------------------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  child: Row(
                    children: [
                      // Search capsule input
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color:const Color(0xFFF9B378),
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: const Color(0xFFFFDFC2),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search,color: Color(0xFF757575),size: 22),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF212121),
                                  ),
                                 decoration: const InputDecoration(
                                    hintText: 'Search',
                                    hintStyle: TextStyle(fontSize: 14,color: Color(0xFF9E9E9E)),
                                    filled: true,
                                    fillColor: Color(0xFFF9B378),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              // const Icon(Icons.mic_none_outlined,color: Color(0xFF616161),size: 22),
                              IconButton(
                                onPressed: _toggleListening,
                                icon: Icon(
                                  _isListening? Icons.mic : Icons.mic_none_outlined,
                                  color: _isListening? Colors.red : const Color(0xFF616161),
                                  size: 22,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Transaction History button
                      InkWell(
                        onTap: () => context.push('/upi/history'),
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF9B378),
                            border: Border.all(
                              color: const Color(0xFFFFDFC2),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.history_rounded,
                              color: Color(0xFF424242),
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // UPI Settings / Profile button
                      InkWell(
                        onTap: () => context.push('/upi/settings'),
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF9B378),
                            border: Border.all(
                              color: const Color(0xFFFFD9C2),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person_outline_rounded,
                              color: Color(0xFF424242),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ----------------------------------------------------
              // 2. PROMOTIONAL HERO BANNER
              // ----------------------------------------------------
              SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),child: _buildHeroBanner(context))),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Image.asset(
                AppImg.bannerImg,
                width: 170,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 140,
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.temple_hindu_rounded,
                    size: 110,
                    color: Color(0xFFD48B55),
                  ),
                ),
              ),
                ),
              ),

              // ----------------------------------------------------
              // 3. PRIMARY QUICK ACTIONS ROW (SCAN, MOBILE, BANK, RECHARGE)
              // ----------------------------------------------------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuickActionCircle(
                        label: 'Scan & Pay',
                        icon: AppImg.scanPayImg,
                        gradient: const [Color(0xFFFF7043), Color(0xFFD84315)],
                        onTap: () => context.push('/upi/scan'),
                      ),
                      _buildQuickActionCircle(
                        label: 'Pay to Mobile',
                        icon: AppImg.payTransferImg,
                        gradient: const [Color(0xFF8E24AA), Color(0xFF5E35B1)],
                        onTap: () => context.push('/upi/mobile'),
                      ),
                      _buildQuickActionCircle(
                        label: 'Bank Transfer',
                        icon: AppImg.banktransferImg,
                        gradient: const [Color(0xFF1E88E5), Color(0xFF0D47A1)],
                        onTap: () => context.push('/upi/bank'),
                      ),
                      _buildQuickActionCircle(
                        label: 'Recharge',
                        icon: AppImg.mobileRechargeImg,
                        gradient: const [Color(0xFFE91E63), Color(0xFFC2185B)],
                        onTap: () => BillRechargeSheet.show(
                          context,
                          serviceTitle: 'Mobile Recharges',
                          category: 'Recharges',
                          icon: AppImg.mobileRechargeImg,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ----------------------------------------------------
              // 4. BANK ACCOUNTS & VIEW BALANCE CAROUSEL
              // ----------------------------------------------------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: _buildBankAccountsSection(context),
                ),
              ),

              // ----------------------------------------------------
              // 5. OFFERS & REWARDS SECTION (3 RED GRADIENT CARDS)
              // ----------------------------------------------------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                  child: _buildSectionHeader('Offers & Rewards'),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildOffersRewardsRow(context),
                ),
              ),

              // ----------------------------------------------------
              // 6. RECHARGES SECTION
              // ----------------------------------------------------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                  child: _buildSectionHeader('Recharges'),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _buildRechargesGrid(context),
                ),
              ),

              // ----------------------------------------------------
              // 7. UTILITY BILLS SECTION
              // ----------------------------------------------------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                  child: _buildSectionHeader('Utility Bills'),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _buildUtilityBillsGrid(context),
                ),
              ),

              // ----------------------------------------------------
              // 8. FINANCE & TAX SECTION
              // ----------------------------------------------------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                  child: _buildSectionHeader('Finance & Tax'),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _buildFinanceTaxGrid(context),
                ),
              ),

              // ----------------------------------------------------
              // 9. OTHERS SECTION
              // ----------------------------------------------------
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                  child: _buildSectionHeader('Others'),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: _buildOthersGrid(context),
                ),
              ),

              // Bottom padding for navigation bar clearance
              const SliverToBoxAdapter(child: SizedBox(height: 110)),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // WIDGET BUILDERS
  // ================================================================

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1E1E1E),
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      height: 142,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFFF1E3),
            Color(0xFFFFE0C7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.1),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFFFD5B8),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background temple asset image or decorative graphics
          Positioned(
            right: -10,
            top: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.95,
              child: Image.asset(
                AppImg.bannerImg,
                width: 170,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 140,
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.temple_hindu_rounded,
                    size: 110,
                    color: Color(0xFFD48B55),
                  ),
                ),
              ),
            ),
          ),

          // Gradient scrim to ensure text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.0, 0.58, 1.0],
                  colors: [
                    const Color(0xFFFFF4EB),
                    const Color(0xFFFFF4EB).withValues(alpha: 0.88),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Banner Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BHARTIYA DHARM',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF8B2500),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Support Temples,\nPeople & Causes',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF3E120D),
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const SizedBox(
                      width: 190,
                      child: Text(
                        'Your contribution helps preserve our heritage and keep our traditions alive.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6E4A44),
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),

                // Donate Now button
                InkWell(
                  onTap: () => context.push('/main/donation'),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7E1515), // Deep maroon/burgundy
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7E1515).withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Donate Now',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 13,
                          color: Colors.white,
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
    );
  }

  Widget _buildQuickActionCircle({
    required String label,
    required String icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 78,
        child: Column(
          children: [
            Image.asset(icon),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C2C2C),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankAccountsSection(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // YES BANK Card
              _buildBankCard(
                context: context,
                accountId: 'bank_yes_01',
                bankName: 'Yes Bank',
                accountNumber: 'XX 3287',
                logoColor: const Color(0xFF003B73),
                logoIcon: Icons.check_circle_outline_rounded,
                revealedBalance: state.revealedBalances['bank_yes_01'],
              ),
              const SizedBox(width: 11),

              // AXIS BANK Card
              _buildBankCard(
                context: context,
                accountId: 'bank_axis_02',
                bankName: 'Axis Bank',
                accountNumber: 'XX 4398',
                logoColor: const Color(0xFF97144D),
                logoIcon: Icons.change_history_rounded,
                revealedBalance: state.revealedBalances['bank_axis_02'],
              ),
              const SizedBox(width: 12),

              // Add Account Card
              InkWell(
                onTap: () => context.push('/upi/settings'),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: const Color(0xFFFFD9C2)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add_circle_outline, color: Color(0xFFE65100), size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Add Bank',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE65100),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBankCard({
    required BuildContext context,
    required String accountId,
    required String bankName,
    required String accountNumber,
    required Color logoColor,
    required IconData logoIcon,
    double? revealedBalance,
  }) {
    return Container(
      height: 54,
      padding: const EdgeInsets.fromLTRB(10, 6, 8, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo circle
          Container(width: 36,height: 36,
            decoration: BoxDecoration(shape: BoxShape.circle,color: logoColor),
            child: Icon(logoIcon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),

          // Bank name & Account No
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                bankName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E1E1E),
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                accountNumber,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF757575),
                  height: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // View Balance Pill Button
          if (revealedBalance != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF81C784)),
              ),
              child: Text(
                '₹${revealedBalance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E7D32),
                ),
              ),
            )
          else
            InkWell(
              onTap: () => _handleViewBalance(
                context,
                accountId,
                bankName,
                accountNumber,
              ),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F), // Dark charcoal/black
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'View Balance',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOffersRewardsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildCrimsonCard(
            title: 'Referrals',
            icon: AppImg.referralsImg,
            onTap: () => OffersRewardsSheet.show(context, initialTab: 0),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildCrimsonCard(
            title: 'Offers',
            icon: AppImg.offersImg,
            onTap: () => OffersRewardsSheet.show(context, initialTab: 1),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildCrimsonCard(
            title: 'Rewards',
            icon: AppImg.rewardsImg,
            onTap: () => OffersRewardsSheet.show(context, initialTab: 2),
          ),
        ),
      ],
    );
  }

  Widget _buildCrimsonCard({
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 105,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE80A4F), // Vibrant crimson red
              Color(0xFFB5003A),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE80A4F).withValues(alpha: 0.28),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.2,
                height: 1.2,
              ),
            ),
            // Decorative 3D-styled icon inside
            SizedBox(
              width: 111,
              height: 55,
              // decoration: BoxDecoration(shape: BoxShape.circle,
              //   color: Colors.white.withValues(alpha: 0.18),
              //   border: Border.all(color: Colors.white.withValues(alpha: 0.35),width: 1.5),
              // ),
              child: Center(child: Image.asset(icon)),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // 4-COLUMN SERVICE GRIDS
  // ================================================================

  Widget _buildRechargesGrid(BuildContext context) {
    final items = [
      {'title': 'Mobile\nRecharges', 'icon': AppImg.mobileRechargeImg},
      {'title': 'DTH / Cable\nTV', 'icon': AppImg.dthImg},
      {'title': 'FASTag\nRecharges', 'icon': AppImg.fasTagImg},
      {'title': 'NCMC\nRecharge', 'icon': AppImg.ncmcImg},
      {'title': 'EV\nRecharge', 'icon': AppImg.evImg},
    ];

    return _buildServiceGrid(context, items, 'Recharges');
  }

  Widget _buildUtilityBillsGrid(BuildContext context) {
    final items = [
      {'title': 'Electricity\nBill', 'icon': AppImg.electricityImg},
      {'title': 'Broadband /\nLandline', 'icon': AppImg.broadbandImg},
      {'title': 'Postpaid\nMobile', 'icon': AppImg.postpaidBilesImg},
      {'title': 'Gas Cylinder\nBooking', 'icon': AppImg.gasCylinderImg},
      {'title': 'Water Bill', 'icon': AppImg.waterImg},
      {'title': 'Education', 'icon': AppImg.educationImg},
      {'title': 'Piped Gas', 'icon': AppImg.pipedGasImg},
    ];

    return _buildServiceGrid(context, items, 'Utility Bills');
  }

  Widget _buildFinanceTaxGrid(BuildContext context) {
    final items = [
      {'title': 'Loan EMI', 'icon': AppImg.loanImg},
      {'title': 'Credit Cards', 'icon': AppImg.creditImg},
      {'title': 'Municipal\nTaxes', 'icon': AppImg.municipalImg},
      {'title': 'Traffic\nChallan', 'icon': AppImg.trafficImg},
      {'title': 'LIC /\nInsurance', 'icon': AppImg.licImg},
      {'title': 'NPS', 'icon': AppImg.npsImg},
    ];

    return _buildServiceGrid(context, items, 'Finance & Tax');
  }

  Widget _buildOthersGrid(BuildContext context) {
    final items = [
      {'title': 'LIC /\nInsurance', 'icon': AppImg.licImg},
      {'title': 'Housing\nSociety', 'icon': AppImg.housingSocietyImg},
      {'title': 'Fleet Card\nRecharge', 'icon': AppImg.fleetCardImg},
      {'title': 'Subscriptions', 'icon': AppImg.subscriptionsImg},
      {'title': 'Donation', 'icon': AppImg.donationImg},
      {'title': 'Clubs &\nAssociations', 'icon': AppImg.cludsAssociationsImg},
      {'title': 'Retail', 'icon': AppImg.retalImg},
    ];

    return _buildServiceGrid(context, items, 'Others');
  }

  Widget _buildServiceGrid(
    BuildContext context,
    List<Map<String, String>> items,
    String category,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(vertical: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,mainAxisSpacing: 8,
        crossAxisSpacing: 6,childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final title = (item['title'] as String).replaceAll('\n', ' ');
        final icon = item['icon']as String;
        // final gradient = item['gradient'] as List<Color>;

        return UpiServiceIcon(
          label: item['title'] as String,
          iconWidget: ServiceIconGraphic(icon: icon),
          onTap: () {
            if (title.toLowerCase().contains('donation')) {context.push('/main/donation');} 
            else {BillRechargeSheet.show(context,serviceTitle: title,category: category,icon: icon,);}
          },
        );
      },
    );
  }
}

