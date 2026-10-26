import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/store_home.dart';
import 'store_product_card.dart';

class StoreProductSection extends StatelessWidget {
  final String title;
  final List<StoreProduct> products;

  const StoreProductSection({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (products.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,color: colors.onSurface,
                    height: 1.5, // 24px line height / 16px font size
                    letterSpacing: 0,
                  ),
                ),
                IconButton(onPressed: () => context.pushNamed('cart'), icon: Icon(Icons.chevron_right, color: Color(0xff097939),)),
              ],
            ),
          ),

          const SizedBox(height: 6),
          SizedBox(
            height: 255,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return StoreProductCard(product: products[index]);
              },
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
