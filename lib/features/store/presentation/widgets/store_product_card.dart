import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/store_home.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import 'store_image.dart';


class StoreProductCard extends StatelessWidget {
  final StoreProduct product;

  const StoreProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
       width: 155,height: 250,
        child: Material(
          color: colors.surface,
          elevation: 5,
          shadowColor: const Color(0x18097939),
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              context.pushNamed('product-detail',pathParameters: {'productId': product.id});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                SizedBox(
                  height: 118,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: colors.surfaceContainerHighest,
                        child: CardImage(
                          image: product.image,
                          icon: Icons.shopping_bag_outlined,
                        ),
                      ),
                      // Favorite button
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          width: 27,
                          height: 27,
                          decoration: BoxDecoration(
                            color: const Color(0x88000000),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Rating badge
                      if (product.rating != null)
                        Positioned(
                          bottom: 6,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xCC70401D),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  product.rating!.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.star,size: 16,color: Color(0xFFFFC107)),
                              ],
                            ),
                          ),
                        ),

                      // Image carousel indicator decoration
                      Positioned(
                        bottom: 15,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate( 3,
                              (index) => Container(
                                // margin: const EdgeInsets.symmetric(horizontal: 2),
                                width: index == 0 ?6 : 5,
                                height: index == 0 ? 16 : 10,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: index == 0 ? 1 : 0.5),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Product details
                Expanded(
                  child: Container(height: 92,width: 150,color: Colors.white24,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14, height: 1.3,
                            fontWeight: FontWeight.w500,
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Price and discount
                        Row(
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '₹ ${product.price.toStringAsFixed(0)}',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: colors.onSurface,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 5),

                            if (product.discountPercentage != null)
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F3E5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${product.discountPercentage}% OFF',
                                      style: const TextStyle(
                                        color: Color(0xFF247A24),
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const Spacer(),
                        CustomButton(
                          text: 'Add to Cart',
                          // isLoading: state.isLoading,
                          onPressed: () {
                            context.read<CartBloc>().add(AddProductToCart(productId: product.id,quantity: 1));
                            context.pushNamed('cart');
                          },
                        ),

                        // Add to Cart button
                        SizedBox(
                          width: 132,
                          height: 32,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFD0E5D9),
                              foregroundColor: const Color(0xFF087D3B),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                            ),
                            onPressed: () {
                              context.read<CartBloc>().add(AddProductToCart(productId: product.id,quantity: 1));
                              context.pushNamed('cart');
                            },
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add,size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    'Add to Cart',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        
              ],
            ),
          ),
        ),
  
    );
  }
}
