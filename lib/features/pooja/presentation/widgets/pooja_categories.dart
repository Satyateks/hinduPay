import 'package:flutter/material.dart';

import 'pooja_category_card.dart';

class PoojaCategories extends StatelessWidget {
  const PoojaCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      const PoojaCategoryCardData(
        title: 'Griha Pooja',
        icon: Icons.home_outlined,
      ),
      const PoojaCategoryCardData(
        title: 'Festival',
        icon: Icons.celebration_outlined,
      ),
      const PoojaCategoryCardData(
        title: 'Shanti Pooja',
        icon: Icons.self_improvement,
      ),
      const PoojaCategoryCardData(
        title: 'Special Pooja',
        icon: Icons.temple_hindu,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Pooja Categories',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 105,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return PoojaCategoryCard(data: categories[index], onTap: () {});
            },
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
