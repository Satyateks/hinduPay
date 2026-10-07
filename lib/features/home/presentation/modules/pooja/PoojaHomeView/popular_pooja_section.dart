import 'package:flutter/material.dart';

import 'pooja_card.dart';
import 'pooja_section_header.dart';

class PopularPoojaSection extends StatelessWidget {
  const PopularPoojaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final poojas = [
      const PoojaCardData(
        title: 'Ganesh Pooja',
        subtitle: 'For prosperity & success',
        price: '₹1,100',
      ),
      const PoojaCardData(
        title: 'Satyanarayan Pooja',
        subtitle: 'Peace & prosperity',
        price: '₹2,100',
      ),
      const PoojaCardData(
        title: 'Lakshmi Pooja',
        subtitle: 'Wealth & abundance',
        price: '₹1,500',
      ),
    ];

    return Column(
      children: [
        PoojaSectionHeader(title: 'Popular Pooja', onViewAll: () {}),

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

        const SizedBox(height: 28),
      ],
    );
  }
}
