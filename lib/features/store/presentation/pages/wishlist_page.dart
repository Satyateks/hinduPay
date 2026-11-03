import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../bloc/wishlist/wishlist_bloc.dart';
import '../bloc/wishlist/wishlist_event.dart';
import '../bloc/wishlist/wishlist_state.dart';
import '../../domain/entities/wishlist_item.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WishlistBloc>()..add(const LoadWishlist()),
      child: const _WishlistView(),
    );
  }
}

class _WishlistView extends StatelessWidget {
  const _WishlistView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state.status == WishlistStatus.initial ||
              state.status == WishlistStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == WishlistStatus.failure && state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? 'Unable to load wishlist'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () =>
                        context.read<WishlistBloc>().add(const LoadWishlist()),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 72,
                      color: colors.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your wishlist is empty',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Save your favourite pooja products here.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => context.go('/store'),
                      child: const Text('Explore Store'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<WishlistBloc>().add(const LoadWishlist());
              await Future<void>.delayed(const Duration(milliseconds: 350));
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = state.items[index];

                return _WishlistProductCard(item: item);
              },
            ),
          );
        },
      ),
    );
  }
}

class _WishlistProductCard extends StatelessWidget {
  final WishlistItem item;

  const _WishlistProductCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                context.pushNamed(
                  'product-detail',
                  pathParameters: {'productId': item.productId},
                );
              },
              child: Container(
                width: 96,
                height: 104,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: item.image.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.shopping_bag_outlined, size: 36),
                        ),
                      )
                    : const Icon(Icons.shopping_bag_outlined, size: 36),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.category,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '₹${item.price.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (item.originalPrice != null &&
                          item.originalPrice! > item.price)
                        Text(
                          '₹${item.originalPrice!.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: colors.onSurfaceVariant,
                              ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: item.inStock
                              ? () {
                                  context.pushNamed(
                                    'product-detail',
                                    pathParameters: {
                                      'productId': item.productId,
                                    },
                                  );
                                }
                              : null,
                          child: Text(
                            item.inStock ? 'View Product' : 'Out of Stock',
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remove from wishlist',
                        onPressed: () {
                          context.read<WishlistBloc>().add(
                            RemoveWishlistItem(item.productId),
                          );
                        },
                        icon: const Icon(Icons.favorite, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
