import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/pandit_bloc.dart';
import '../bloc/pandit_state.dart';

class PanditsPage extends StatelessWidget {
  const PanditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Pandits')),
      body: BlocBuilder<PanditBloc, PanditState>(
        builder: (context, state) {
          if (state.status == PanditStatus.loading || state.status == PanditStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == PanditStatus.failure) {
            return Center(child: Text(state.message ?? 'Error loading pandits'));
          }
          if (state.pandits.isEmpty) {
            return const Center(child: Text('No Pandits available'));
          }

          return ListView.builder(
            itemCount: state.pandits.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final pandit = state.pandits[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(pandit.name[0]),
                  ),
                  title: Text(pandit.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(pandit.specialization),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(pandit.rating.toString()),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}