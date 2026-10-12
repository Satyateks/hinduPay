import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hindu_pay/features/store/presentation/bloc/product_detail/product_detail_event.dart';

import '../../domain/entities/store_home.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/product_detail/product_detail_bloc.dart';
import 'store_image.dart';

class StoreProductCard extends StatelessWidget {
  final StoreProduct product;

  const StoreProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: 142,
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            context.pushNamed('product-detail',pathParameters: {'productId': product.id});
          },
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 128,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: StoreImage(
                          image: product.image,
                          icon: Icons.shopping_bag_outlined,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        width: 27,
                        height: 27,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          size: 16,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                if (product.rating != null)
                  Row(
                    children: [
                      Icon(Icons.star, size: 13, color: colors.secondary),
                      const SizedBox(width: 2),
                      Text(
                        product.rating!.toStringAsFixed(1),
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),

                const SizedBox(height: 2),

                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                      ),
                    ),

                    const SizedBox(width: 5),

                    if (product.discountPercentage != null)
                      Text(
                        '${product.discountPercentage}% OFF',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 5),

                SizedBox(
                  width: double.infinity,
                  height: 31,
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<ProductDetailBloc>().add(AddProductToCart(productId: product.id,quantity: 1) as ProductDetailEvent);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: colors.primary,
                      side: BorderSide(color: colors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '+ Add to Cart',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
