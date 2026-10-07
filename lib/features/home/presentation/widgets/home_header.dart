import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'ॐ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Dharmik Seva',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 23),
          ),

          IconButton(onPressed: () {}, icon: const Icon(Icons.menu, size: 23)),
        ],
      ),
    );
  }
}
