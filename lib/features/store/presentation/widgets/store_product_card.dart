import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/store_home.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import 'store_image.dart';

class StoreProductCard extends StatelessWidget {
  final StoreProduct product;

  const StoreProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: 148,height: 225,
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.pushNamed('product-detail',pathParameters: {'productId': product.id});
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 6,right: 6,bottom: 12),
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
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.outlineVariant,width: 1)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: CardImage(
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
                    if (product.rating != null)
                    Positioned(
                      bottom: 5,
                      left: 5,
                      child: Container(
                        // width: 27,
                        height: 27,
                        decoration: BoxDecoration(
                          color: colors.onSecondary,
                          shape: BoxShape.rectangle,
                        ),
                        child: 
                  Row(
                    children: [
                      Icon(Icons.star, size: 13, color: colors.secondary),
                      const SizedBox(width: 2),
                      Text(
                        product.rating!.toStringAsFixed(1),
                        style: theme.textTheme.labelSmall,
                      ),
                      const SizedBox(width: 2),
                    ],
                  ),
               
               
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,height: 20/14
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,fontSize: 16,
                        color: colors.onSurface,fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),

                    const SizedBox(width: 5),

                    if (product.discountPercentage != null)
                      Text(
                        '${product.discountPercentage}% OFF',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Color(0xff247A24),fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ), const SizedBox(height: 2),
                 SizedBox(height: 32,width: 132,
                   child: FilledButton(    
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0x33097939),
                      foregroundColor: const Color(0xFF097939),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(76),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {context.read<CartBloc>().add(AddProductToCart(productId: product.id, quantity: 1));context.pushNamed('cart');},
                    child: const Text('+  Add to Cart',
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                        ),),
                    ),
                 ),
              /*  SizedBox(
                  width: double.infinity,
                  height: 31,
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(AddProductToCart(productId: product.id, quantity: 1));
                      context.pushNamed('cart');
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
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
