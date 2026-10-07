import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final pandit = state.pandits[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              child: Text(pandit.name[0], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(pandit.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(pandit.specialization, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text(pandit.rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Booking page par navigate karein aur pandit/pooja pass karein
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PanditBookingPage(
                                      pandit: pandit, 
                                      selectedPooja: state.selectedFilter == 'All' ? 'General Puja' : state.selectedFilter,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Book'),
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