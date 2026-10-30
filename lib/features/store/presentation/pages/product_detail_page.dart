import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/product_details.dart';
import '../../domain/entities/wishlist_item.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/product_detail/product_detail_bloc.dart';
import '../bloc/product_detail/product_detail_event.dart';
import '../bloc/product_detail/product_detail_state.dart';
import '../bloc/wishlist/wishlist_bloc.dart';
import '../bloc/wishlist/wishlist_event.dart';
import '../widgets/included_items.dart';
import '../widgets/product_details_card.dart';
import '../widgets/product_gallery.dart';
import '../widgets/recommended_products.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductDetailBloc>(
          create: (_) =>
              getIt<ProductDetailBloc>()
                ..add(LoadProductDetail(productId: productId)),
        ),
        BlocProvider<CartBloc>(
          create: (_) => getIt<CartBloc>()..add(const LoadCart()),
        ),
      ],
      child: const ProductDetailView(),
    );
  }
}

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            return Text(
              state.product?.name ?? 'Product Details',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Plus Jakarta Sans',
              ),
            );
          },
        ),
        actions: [
          BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (context, state) {
              final product = state.product;

              return IconButton(
                onPressed: product == null
                    ? null
                    : () {
                        final item = WishlistItem(
                          id: 'wish_${product.id}',
                          productId: product.id,
                          name: product.name,
                          image: product.images.isNotEmpty
                              ? product.images.first
                              : '',
                          price: product.price,
                          originalPrice: product.originalPrice,
                          category: product.name,
                        );

                        context.read<WishlistBloc>().add(AddWishlistItem(item));
                      },
                icon: const Icon(Icons.favorite_border, size: 23),
              );
            },
          ),
          IconButton(
            onPressed: () {
              // Add share functionality here.
            },
            icon: const Icon(Icons.share_outlined, size: 21),
          ),
        ],
      ),

      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state.status == ProductDetailStatus.initial || state.status == ProductDetailStatus.loading) return const Center(child: CircularProgressIndicator());
          if (state.status == ProductDetailStatus.failure) return Center(child: Text(state.errorMessage ?? 'Something went wrong'));
          
          final product = state.product;
          if (product == null) return const Center(child: Text('Product not available'));

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 6, bottom: 16),
                  children: [
                    // Product image gallery
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ProductGallery(images: product.images),
                    ),

                    // Price, discount and rating
                    _ProductPrice(product: product),

                    // Product name and description
                    _ProductDescription(product: product),

                    // Included items section
                    _DetailSectionCard(
                      child: Column(
                        children: [
                          IncludedItems(items: product.includedItems),
                        ],
                      ),
                    ),

                    // Product specifications
                    _DetailSectionCard(child: ProductDetails(product: product)),

                    // Delivery and trust information
                    _DeliveryTrust(product: product),
                TextButton.icon(
                  onPressed: () {
                    context.pushNamed(
                      'product-reviews',
                      pathParameters: {'productId': product.id},
                    );
                  },
                  icon: const Icon(Icons.star_outline),
                  label: const Text('Ratings & Reviews'),
                ),
                    // Recommended products
                    RecommendedProducts(products: product.recommendedProducts),
                  ],
                ),
              ),

              // Fixed bottom action bar
              Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: OutlinedButton(
                            onPressed: () {
                              context.read<CartBloc>().add(
                                AddProductToCart(
                                  productId: product.id,
                                  quantity: 1,
                                ),
                              );
                              context.pushNamed('cart');
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF087D3B),
                              side: const BorderSide(color: Color(0xFF087D3B)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Add to cart',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: FilledButton(
                            onPressed: () {
                              context.read<CartBloc>().add(
                                AddProductToCart(
                                  productId: product.id,
                                  quantity: 1,
                                ),
                              );

                              context.pushNamed('payment');
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF087D3B),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Buy Now',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailSectionCard extends StatelessWidget {
  final Widget child;

  const _DetailSectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _ProductPrice extends StatelessWidget {
  final ProductDetail product;

  const _ProductPrice({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal:8),
      child: Row(
        children: [
          Text(
            '₹ ${product.price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 24,height: 32/24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),

          if (product.originalPrice != null) ...[
            const SizedBox(width: 6),
            Text(
              '₹${product.originalPrice!.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],

          if (product.discountPercentage != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F4E8),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                '${product.discountPercentage}% OFF',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF247A24),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],

          const Spacer(),

          if (product.rating != null)
            Row(
              children: [
                Text(
                  product.rating!.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.star, size: 16, color: Color(0xFFFFB900)),
                Text(
                  '(${product.reviewCount!.toString()})',
                  style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ProductDescription extends StatelessWidget {
  final ProductDetail product;

  const _ProductDescription({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 5, 8, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,height: 24/16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              height: 1.4,fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryTrust extends StatelessWidget {
  final ProductDetail product;

  const _DeliveryTrust({required this.product});

  @override
  Widget build(BuildContext context) {
    final info = product.deliveryInformation;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: _TrustCard(
              icon: Icons.local_shipping_outlined,
              text: info.deliveryText,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TrustCard(
              icon: Icons.verified_outlined,
              text: info.returnText,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TrustCard(
              icon: Icons.workspace_premium_outlined,
              text: info.trustedText,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TrustCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFD8F0E3),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF087D3B)),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              text,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 9,
                height: 1.25,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
