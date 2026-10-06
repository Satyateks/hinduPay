import 'package:flutter/material.dart';

class ShopHomeView extends StatelessWidget {
  const ShopHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        _ShopBanner(),
        _ShopCategories(),
        _FeaturedProducts(),
        _PopularProducts(),
      ],
    );
  }
}

class _ShopBanner extends StatelessWidget {
  const _ShopBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: const Center(child: Text('Hindu Shop')),
    );
  }
}

class _ShopCategories extends StatelessWidget {
  const _ShopCategories();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Shop Categories'),
    );
  }
}

class _FeaturedProducts extends StatelessWidget {
  const _FeaturedProducts();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Featured Products'),
    );
  }
}

class _PopularProducts extends StatelessWidget {
  const _PopularProducts();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Popular Products'),
    );
  }
}
