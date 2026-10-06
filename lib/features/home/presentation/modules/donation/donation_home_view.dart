import 'package:flutter/material.dart';

class DonationHomeView extends StatelessWidget {
  const DonationHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        _DonationBanner(),
        _DonationCategories(),
        _FeaturedCauses(),
        _PopularCauses(),
      ],
    );
  }
}

class _DonationBanner extends StatelessWidget {
  const _DonationBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: const Center(child: Text('Donation')),
    );
  }
}

class _DonationCategories extends StatelessWidget {
  const _DonationCategories();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Donation Categories'),
    );
  }
}

class _FeaturedCauses extends StatelessWidget {
  const _FeaturedCauses();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Featured Causes'),
    );
  }
}

class _PopularCauses extends StatelessWidget {
  const _PopularCauses();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Popular Causes'),
    );
  }
}
