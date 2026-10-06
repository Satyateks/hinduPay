import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeModuleTabs extends StatelessWidget {
  const HomeModuleTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.selectedModule != current.selectedModule,
      builder: (context, state) {
        return SizedBox(
          height: 86,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: HomeModule.values.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final module = HomeModule.values[index];

              return _ModuleTab(
                module: module,
                selected: module == state.selectedModule,
                onTap: () {
                  context.read<HomeBloc>().add(HomeModuleChanged(module));
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _ModuleTab extends StatelessWidget {
  final HomeModule module;
  final bool selected;
  final VoidCallback onTap;

  const _ModuleTab({
    required this.module,
    required this.selected,
    required this.onTap,
  });

  String get title {
    switch (module) {
      case HomeModule.pooja:
        return 'Pooja';
      case HomeModule.pandit:
        return 'Pandit';
      case HomeModule.darshan:
        return 'Darshan';
      case HomeModule.donation:
        return 'Donation';
      case HomeModule.shop:
        return 'Shop';
    }
  }

  IconData get icon {
    switch (module) {
      case HomeModule.pooja:
        return Icons.temple_hindu;
      case HomeModule.pandit:
        return Icons.person;
      case HomeModule.darshan:
        return Icons.account_balance;
      case HomeModule.donation:
        return Icons.volunteer_activism;
      case HomeModule.shop:
        return Icons.shopping_bag;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
