import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hindu_pay/core/widgets/app_img.dart';
import '../../../../app/theme/app_colors.dart';
import '../bloc/pandit_bloc.dart';
import '../bloc/pandit_event.dart';
import '../bloc/pandit_state.dart';
import 'pandit_booking_page.dart';

class PanditsPage extends StatelessWidget {
  const PanditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Page open hote hi data fetch karein
    context.read<PanditBloc>().add(FetchPanditsEvent());

    return Scaffold(
      appBar: AppBar(title: const Text('Book a Pandit')),
      body: Column(
        children: [
          // --- 1. Pooja Filter Horizontal List ---
          SizedBox(
            height: 60,
            child: BlocBuilder<PanditBloc, PanditState>(
              builder: (context, state) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  itemCount: state.poojaCategories.length,
                  itemBuilder: (context, index) {
                    final category = state.poojaCategories[index];
                    final isSelected = state.selectedFilter == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          // Filter change event trigger karein
                          context.read<PanditBloc>().add(FetchPanditsEvent(poojaFilter: category));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          const Divider(height: 1),

          // --- 2. Pandit List Based on Filter ---
          Expanded(
            child: BlocBuilder<PanditBloc, PanditState>(
              builder: (context, state) {
                if (state.status == PanditStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.pandits.isEmpty) {
                  return const Center(child: Text('No Pandits available for this Pooja'));
                }

                return ListView.builder(
                  itemCount: state.pandits.length,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemBuilder: (context, index) {
                    final pandit = state.pandits[index];
                    final colorScheme = Theme.of(context).colorScheme;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shadowColor: Colors.black.withValues(alpha: 0.06),
                      color: colorScheme.surface,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pandit profile section
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 76,
                                  height: 76,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      AppImg.pandirmanImg,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.person,
                                          size: 42,
                                          color: colorScheme.primary,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pandit.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          height: 1.25,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 6,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryGreen.withValues(
                                                alpha: 0.10,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.verified,
                                                  size: 14,
                                                  color: AppColors.primaryGreen,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Verified',
                                                  style: TextStyle(
                                                    color: AppColors.primaryGreen,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.amber.withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.star_rounded,
                                                  size: 15,
                                                  color: Colors.orange,
                                                ),
                                                const SizedBox(width: 3),
                                                Text(
                                                  pandit.rating.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            Divider(
                              height: 1,
                              color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                            ),
                            const SizedBox(height: 14),

                            // Location
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 19,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    pandit.location,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Specialization
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.auto_awesome_outlined,
                                  size: 19,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    pandit.specialization,
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.4,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // Booking CTA
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PanditBookingPage(
                                        pandit: pandit,
                                        selectedPooja:
                                            state.selectedFilter == 'All'
                                                ? 'General Puja'
                                                : state.selectedFilter,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.calendar_month_rounded, size: 19),
                                label: const Text(
                                  'Book Now',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }
}