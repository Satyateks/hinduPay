import 'package:flutter/material.dart';

class PanditHomeView extends StatelessWidget {
  const PanditHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        _PanditBanner(),
        _PanditSearch(),
        _PanditCategories(),
        _PopularPandits(),
      ],
    );
  }
}

class _PanditBanner extends StatelessWidget {
  const _PanditBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: const Center(child: Text('Pandit Booking')),
    );
  }
}

class _PanditSearch extends StatelessWidget {
  const _PanditSearch();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Pandit',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}

class _PanditCategories extends StatelessWidget {
  const _PanditCategories();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Pandit Categories'),
    );
  }
}

class _PopularPandits extends StatelessWidget {
  const _PopularPandits();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Popular Pandits'),
    );
  }
}
