import 'package:flutter/material.dart';

import '../../domain/entities/home_data.dart';

class QuickActions extends StatelessWidget {
  final List<HomeQuickAction> actions;

  const QuickActions({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    final items = actions.isNotEmpty ? actions : _defaultActions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 6,
          childAspectRatio: 0.95,
        ),
        itemBuilder: (context, index) {
          final item = items[index];

          return _QuickActionItem(
            item: item,
            onTap: () {
              // Baad mein GoRouter navigation add karenge.
            },
          );
        },
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final HomeQuickAction item;
  final VoidCallback onTap;

  const _QuickActionItem({required this.item, required this.onTap});

  IconData _getIcon(String value) {
    switch (value.toLowerCase()) {
      case 'donation':
      case 'daan':
      case 'daan & seva':
        return Icons.volunteer_activism;

      case 'pooja':
      case 'pooja & anushthan':
        return Icons.auto_awesome;

      case 'pandit':
      case 'pandit ji':
        return Icons.person;

      case 'mandir':
      case 'temple':
        return Icons.temple_hindu;

      case 'prasad':
        return Icons.restaurant;

      case 'sanskar':
        return Icons.local_florist;

      case 'vivah':
      case 'vivah sanskar':
        return Icons.favorite;

      case 'yatra':
        return Icons.directions_bus;

      default:
        return Icons.auto_awesome;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              _getIcon(item.title),
              color: theme.colorScheme.primary,
              size: 25,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

const List<HomeQuickAction> _defaultActions = [
  HomeQuickAction(id: '1', title: 'Daan & Seva', icon: 'donation'),
  HomeQuickAction(id: '2', title: 'Pooja & Anushthan', icon: 'pooja'),
  HomeQuickAction(id: '3', title: 'Pandit Ji', icon: 'pandit'),
  HomeQuickAction(id: '4', title: 'Mandir', icon: 'mandir'),
  HomeQuickAction(id: '5', title: 'Prasad', icon: 'prasad'),
  HomeQuickAction(id: '6', title: 'Sanskar', icon: 'sanskar'),
  HomeQuickAction(id: '7', title: 'Vivah Sanskar', icon: 'vivah sanskar'),
  HomeQuickAction(id: '8', title: 'Yatra', icon: 'yatra'),
];
