import 'package:flutter/material.dart';

import '../../domain/entities/store_home.dart';
import 'store_image.dart';

class StoreCategoryList extends StatelessWidget {
  final List<StoreCategory> categories;

  const StoreCategoryList({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (categories.isEmpty) return const SizedBox.shrink(); 

    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];

          return SizedBox(
            width: 72,height: 92,
            child: Column(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1F5E9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x7CB7931F),width: 1),
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(15),
                    child: StoreImage(image: category.image,icon: Icons.category_outlined),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  category.name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onSurface,fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

