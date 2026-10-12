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

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 108,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];

          return SizedBox(
            width: 62,
            child: Column(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surfaceContainerHighest,
                    border: Border.all(
                      color: colors.outlineVariant,
                    ),
                  ),
                  child: ClipOval(
                    child: StoreImage(
                      image: category.image,
                      icon: Icons.category_outlined,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  category.name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w500,
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