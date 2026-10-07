import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import 'donation_details_page.dart';

class DonateHomeScreen extends StatelessWidget {
  const DonateHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Stack with Background Image
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde'), // Replace with your temple banner
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    padding: const EdgeInsets.only(top: 40, left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back_ios, size: 14),
                              SizedBox(width: 4),
                              Text('Daan & Seva', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Donate to Temples',
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Support temple maintenance rituals\nand community seva',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Floating Search Card
                Positioned(
                  top: 170,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Dharmik Seva', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 12),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Search temple by name, city or deity',
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(color: AppColors.borderGrey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildChip('Ram Mandir', true),
                              _buildChip('Kashi Vishwanath', false),
                              _buildChip('Tirupati', false),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {debugPrint("Button Pressed!"); // Console me check karne ke liye
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const DonationDetailScreen()),
                              );},
                            child: const Text('Search', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRedLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, color: AppColors.primaryRed, size: 18),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Show temples near me', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    Text('Support nearby temples', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {debugPrint("Button Pressed!"); // Console me check karne ke liye
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const DonationDetailScreen()),
                              );},
                                child: const Text('Use My Location', style: TextStyle(color: AppColors.primaryRed, fontSize: 11)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 290), // Spacing for floating card

            // Trust Badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBadge(Icons.verified_user, 'Verified\nTemples'),
                  _buildBadge(Icons.security, 'Secure\nDonations'),
                  _buildBadge(Icons.analytics, 'Transparent\nImpact'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Explore by category
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Explore by category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryItem('Popular\nTemples', Icons.temple_hindu),
                      _buildCategoryItem('Shiv\nTemples', Icons.brightness_low),
                      _buildCategoryItem('Jyotirlingas', Icons.wb_sunny),
                      _buildCategoryItem('Devi\nTemples', Icons.local_florist),
                      _buildCategoryItem('Vaishnav\nTemples', Icons.star),
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

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryRedLight : Colors.grey[200],
        border: Border.all(color: isSelected ? AppColors.primaryRed : Colors.transparent),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primaryRed : Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.orange),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 11, height: 1.1)),
      ],
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.orange[50],
          child: Icon(icon, color: Colors.orange),
        ),
        const SizedBox(height: 6),
        Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}