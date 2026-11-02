import 'package:flutter/material.dart';

class StoreHeader extends StatelessWidget {
  const StoreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Shopping',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,fontSize:20,
                color: colors.onSurface,height: 1.5
              ),
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: colors.onSurface),
          ),

          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu, color: colors.onSurface),
          ),
        ],
      ),
    );
  }
}
