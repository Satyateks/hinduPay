import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/product_details.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';

class RecommendedProducts extends StatelessWidget {
  final List<StoreProduct> products;

  const RecommendedProducts({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'You May Also Like',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
              ),
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            height: 177,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 112,
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'product-detail',
            pathParameters: {'productId': product.id},
          );
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFEAEAEA), width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          color: const Color(0xFFF4F0EB),
                          child: const Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 25,
                              color: Color(0xFF087D3B),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 5),

              // Product name
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),

              const SizedBox(height: 3),

              // Product price
              Text(
                '₹${product.price.toStringAsFixed(0)}',
                maxLines: 1,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 5),

              // Add to Cart
              SizedBox(
                width: double.infinity,
                height: 28,
                child: FilledButton(
                  onPressed: () {
                    context.read<CartBloc>().add(
                      AddProductToCart(productId: product.id, quantity: 1),
                    );

                    context.pushNamed('cart');
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFD8EBDD),
                    foregroundColor: const Color(0xFF087D3B),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '+ Add to Cart',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
