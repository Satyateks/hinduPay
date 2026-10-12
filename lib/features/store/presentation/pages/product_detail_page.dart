import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hindu_pay/app/theme/app_colors.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/product_details.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/product_detail/product_detail_bloc.dart';
import '../bloc/product_detail/product_detail_event.dart';
import '../bloc/product_detail/product_detail_state.dart';
import '../widgets/included_items.dart';
import '../widgets/product_details_card.dart';
import '../widgets/product_gallery.dart';
import '../widgets/recommended_products.dart';
 
class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductDetailBloc>(
          create: (_) => getIt<ProductDetailBloc>()
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Puja Thali Set'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
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
                  padding: const EdgeInsets.only(bottom: 20),
                  children: [
                    ProductGallery(images: product.images),
                    _ProductPrice(product: product),
                    _ProductDescription(product: product),
                    IncludedItems(items: product.includedItems),
                    ProductDetails(product: product),
                    _DeliveryTrust(product: product),
                    RecommendedProducts(products: product.recommendedProducts),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      offset: const Offset(0, -3),
                      color: colors.shadow.withValues(alpha: 0.10),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [

                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {print('................');
                            context.read<CartBloc>().add(
                              AddProductToCart(
                                productId: product.id, 
                                quantity: 1,
                              ),
                            );
                          },
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              color: AppColors.discountGreen,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          onPressed: () { },
                          child: const Text('Buy Now'),
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

 
class _ProductPrice extends StatelessWidget {
  final ProductDetail product;

  const _ProductPrice({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Row(
        children: [
          Text(
            '₹${product.price.toStringAsFixed(0)}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          if (product.originalPrice != null) ...[
            const SizedBox(width: 8),
            Text(
              '₹${product.originalPrice!.toStringAsFixed(0)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],

          if (product.discountPercentage != null) ...[
            const SizedBox(width: 8),
            Text(
              '${product.discountPercentage}% OFF',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],

          const Spacer(),

          if (product.rating != null)
            Row(
              children: [
                Icon(Icons.star, size: 15, color: colors.secondary),
                const SizedBox(width: 2),
                Text('${product.rating}', style: theme.textTheme.labelMedium),
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          Text(product.description, style: theme.textTheme.bodySmall),
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
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 78,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 21, color: colors.primary),
          const SizedBox(height: 5),
          Text(
            text,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
  }
}

 