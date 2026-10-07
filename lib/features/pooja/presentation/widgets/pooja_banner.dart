import 'package:flutter/material.dart';

class PoojaBanner extends StatelessWidget {
  const PoojaBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Your Pooja',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Perform sacred rituals\nfrom the comfort of your home',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                ElevatedButton(onPressed: () {}, child: const Text('Book Now')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
