import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Namaste 🙏',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Welcome to Hindu Pay',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),

          CircleAvatar(
            radius: 20,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person_outline),
            ),
          ),
        ],
      ),
    );
  }
}
