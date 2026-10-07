import 'package:flutter/material.dart';

import 'pooja_card.dart';
import 'pooja_section_header.dart';

class RecommendedPoojaSection extends StatelessWidget {
  const RecommendedPoojaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final poojas = [
      const PoojaCardData(
        title: 'Rudrabhishek',
        subtitle: 'For peace & positivity',
        price: '₹2,500',
      ),
      const PoojaCardData(
        title: 'Navgraha Pooja',
        subtitle: 'Planetary peace',
        price: '₹3,100',
      ),
    ];

    return Column(
      children: [
        PoojaSectionHeader(title: 'Recommended For You', onViewAll: () {}),

        SizedBox(
          height: 245,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: poojas.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return PoojaCard(data: poojas[index], onTap: () {});
            },
          ),
        ),
      ],
    );
  }
}
