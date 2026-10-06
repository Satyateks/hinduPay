import 'package:flutter/material.dart';

class PoojaHomeView extends StatelessWidget {
  const PoojaHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: const [
        _PoojaBanner(),
        _PoojaCategories(),
        _PopularPooja(),
        _RecommendedPooja(),
      ],
    );
  }
}

class _PoojaBanner extends StatelessWidget {
  const _PoojaBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: const Center(child: Text('Pooja Banner')),
    );
  }
}

class _PoojaCategories extends StatelessWidget {
  const _PoojaCategories();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Pooja Categories'),
    );
  }
}

class _PopularPooja extends StatelessWidget {
  const _PopularPooja();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Popular Pooja'),
    );
  }
}

class _RecommendedPooja extends StatelessWidget {
  const _RecommendedPooja();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Recommended Pooja'),
    );
  }
}
