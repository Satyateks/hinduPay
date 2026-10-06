import 'package:flutter/material.dart';

class DarshanHomeView extends StatelessWidget {
  const DarshanHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        _DarshanBanner(),
        _NearbyTemples(),
        _PopularTemples(),
        _UpcomingDarshan(),
      ],
    );
  }
}

class _DarshanBanner extends StatelessWidget {
  const _DarshanBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: const Center(child: Text('Temple Darshan')),
    );
  }
}

class _NearbyTemples extends StatelessWidget {
  const _NearbyTemples();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Nearby Temples'),
    );
  }
}

class _PopularTemples extends StatelessWidget {
  const _PopularTemples();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Popular Temples'),
    );
  }
}

class _UpcomingDarshan extends StatelessWidget {
  const _UpcomingDarshan();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Upcoming Darshan'),
    );
  }
}
