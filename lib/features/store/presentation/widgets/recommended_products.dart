
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/product_details.dart';

class RecommendedProducts extends StatelessWidget {
  final List<StoreProduct> products;

  const RecommendedProducts({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'You May Also Like',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            height: 240,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 142,
                  child: _RecommendationCard(product: products[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class _RecommendationCard extends StatelessWidget {
  final StoreProduct product;

  const _RecommendationCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                product.image,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    color: colors.surfaceContainerHighest,
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: colors.primary,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            '₹${product.price.toStringAsFixed(0)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          SizedBox(
            width: double.infinity,
            height: 29,
            child: OutlinedButton(
              onPressed: () {context.push('cart');},
              child: const Text('+ Add to Cart', style: TextStyle(fontSize: 10)),
            ),
          ),
        ],
      ),
    );
  }
}
