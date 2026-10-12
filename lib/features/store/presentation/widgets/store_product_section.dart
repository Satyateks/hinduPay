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
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {context.pushNamed('cart');},
                  child: const Text('See all'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          SizedBox(
            height: 242,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return StoreProductCard(product: products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

