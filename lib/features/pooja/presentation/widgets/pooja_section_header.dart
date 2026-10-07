import 'package:flutter/material.dart';

class PoojaSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const PoojaSectionHeader({super.key, required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(onPressed: onViewAll, child: const Text('View All')),
        ],
      ),
    );
  }
}
