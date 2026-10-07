import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../domain/usecases/get_pooja_categories.dart';
import '../../domain/usecases/get_pooja_details.dart';
import '../../domain/usecases/get_poojas.dart';
import '../bloc/pooja_bloc.dart';
import '../bloc/pooja_event.dart';
import '../bloc/pooja_state.dart';

class PoojaListPage extends StatelessWidget {
  const PoojaListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PoojaBloc(
        getPoojas: getIt<GetPoojas>(),
        getPoojaDetail: getIt<GetPoojaDetail>(),
        getPoojaCategories: getIt<GetPoojaCategories>(),
      )..add(const LoadPoojas()),
      child: const _PoojaListView(),
    );
  }
}

class _PoojaListView extends StatelessWidget {
  const _PoojaListView();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pooja')),
      body: BlocBuilder<PoojaBloc, PoojaState>(
        builder: (context, state) {
          if (state.status == PoojaStatus.loading)return const Center(child: CircularProgressIndicator());
          if (state.status == PoojaStatus.failure)return Center(child: Text(state.errorMessage ?? 'Something went wrong'));
          if (state.poojas.isEmpty) return const Center(child: Text('No Pooja found'));
          return ListView.builder(
            itemCount: state.poojas.length,
            itemBuilder: (context, index) {
              final pooja = state.poojas[index];
              return ListTile(
                title: Text(pooja.name),
                subtitle: Text(pooja.description),
                trailing: Text('₹${pooja.price.toStringAsFixed(0)}'),
              );
            },
          );
        },
      ),
    );
  }
}
