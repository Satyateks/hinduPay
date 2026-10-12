import 'package:flutter/material.dart';
import 'package:hindu_pay/core/widgets/app_img.dart';
import '../../../../app/theme/app_colors.dart';
import 'donation_details_page.dart';
import 'donation_temple_list.dart';

class DonateHomeScreen extends StatefulWidget {
  const DonateHomeScreen({super.key});

  @override
  State<DonateHomeScreen> createState() => _DonateHomeScreenState();
}

class _DonateHomeScreenState extends State<DonateHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedTemple = 'Ram Mandir';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchTemple() {
    debugPrint('Search: ${_searchController.text}');
    // context.push('/donation/templeList');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TempleListScreen()),
    );
  }

  void _useMyLocation() {
    debugPrint('Use My Location pressed');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DonationDetailScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,

      // IMPORTANT:
      // Gesture/touch handling yahan normal rahega.
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --------------------------------------------------
            // HEADER + FLOATING CARD
            // --------------------------------------------------
            SizedBox(
              // Stack ko fixed height di gayi hai.
              // Design same rahega, but hit testing proper hoga.
              height: 460,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // --------------------------------------------------
                  // HEADER
                  // --------------------------------------------------
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 260,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppImg.donatTempleImg),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        padding: const EdgeInsets.only(top: 40, left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios,
                                    fontWeight: FontWeight.w700,
                                    size: 18,
                                    color: AppColors.black,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Daan & Seva',
                                    style: TextStyle(
                                      fontSize: 18,
                                      height: 1.6,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Donate to Temples',
                              style: TextStyle(
                                color: AppColors.darkGrey,
                                fontSize: 24,
                                height: 2.0,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Support temple maintenance rituals\n'
                              'and community seva',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // --------------------------------------------------
                  // FLOATING SEARCH CARD
                  // --------------------------------------------------
                  Positioned(
                    top: 210,
                    left: 16,
                    right: 16,

                    // IMPORTANT:
                    // Card khud apne complete area ko receive karega.
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dharmik Seva',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // --------------------------------------------------
                            // SEARCH INPUT
                            // --------------------------------------------------
                            TextField(
                              controller: _searchController,
                              enabled: true,
                              readOnly: false,
                              textInputAction: TextInputAction.search,
                              onChanged: (value) {
                                debugPrint('Input: $value');
                              },
                              onSubmitted: (value) {
                                _searchTemple();
                              },
                              decoration: InputDecoration(
                                hintText:
                                    'Search temple by name, city or deity',
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                    color: AppColors.borderGrey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                    color: AppColors.borderGrey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // --------------------------------------------------
                            // CHIPS
                            // --------------------------------------------------
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildChip('Ram Mandir'),
                                  _buildChip('Kashi Vishwanath'),
                                  _buildChip('Tirupati'),
                                  _buildChip('Kashi Vishwanath'),
                                  _buildChip('Tirupati'),
                                  _buildChip('Ram Mandir'),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // --------------------------------------------------
                            // SEARCH BUTTON
                            // --------------------------------------------------
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryRed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () {
                                  debugPrint('SEARCH BUTTON PRESSED');
                                  _searchTemple();
                                },
                                child: const Text(
                                  'Search',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // --------------------------------------------------
                            // LOCATION
                            // --------------------------------------------------
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryRedLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: AppColors.primaryRed,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Show temples near me',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Support nearby temples',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _useMyLocation,
                                    child: const Text(
                                      'Use My Location',
                                      style: TextStyle(
                                        color: AppColors.primaryRed,
                                        fontSize: 11,
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
                  ),
                ],
              ),
            ),

            // --------------------------------------------------
            // TRUST BADGES
            // --------------------------------------------------
            const SizedBox(height: 100),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFDEFF2), Color(0xFFFFFFFF)],
                  stops: [0.422, 1.0],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBadge(AppImg.verifyedTempleImg, 'Verified\nTemples'),
                  _buildBadge(AppImg.secureDonationImg, 'Secure\nDonations'),
                  _buildBadge(AppImg.transparentImpactImg,'Transparent\nImpact'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------
            // EXPLORE CATEGORY
            // --------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore by category',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryItem('Popular\nTemples',AppImg.yatraImg),
                      _buildCategoryItem('Shiv\nTemples', AppImg.kashiVvishnathImg),
                      _buildCategoryItem('Jyotirlingas', AppImg.poojaAnushthanImg),
                      _buildCategoryItem('Devi\nTemples', AppImg.mandirImg),
                      _buildCategoryItem('Vaishnav\nTemples',AppImg.verifyedTempleImg),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // CHIP
  // --------------------------------------------------
  Widget _buildChip(String label) {
    final bool isSelected = selectedTemple == label;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          selectedTemple = label;
          _searchController.text = label;
          _searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: _searchController.text.length),
          );
        });

        debugPrint('Chip selected: $label');
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRedLight : Colors.grey[200],
          border: Border.all(
            color: isSelected ? AppColors.error : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w500: FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // BADGE
  // --------------------------------------------------
  Widget _buildBadge(String icon, String text) {
    return Row(
      children: [
        Image.asset(icon, height: 24, width: 24),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // CATEGORY
  // --------------------------------------------------
  Widget _buildCategoryItem(String title, String icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor:AppColors.primaryRedLight,
          child: Image.asset(icon),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
