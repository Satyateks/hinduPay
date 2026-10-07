// State
import '../../domain/entities/pandit.dart';

enum PanditStatus { initial, loading, loaded, failure }

class PanditState {
  final PanditStatus status;
  final List<Pandit> pandits;
  final List<String> poojaCategories;
  final String selectedFilter;
  final String? message;

  const PanditState({
    this.status = PanditStatus.initial,
    this.pandits = const [],
    this.poojaCategories = const ['All'],
    this.selectedFilter = 'All',
    this.message,
  });

  PanditState copyWith({
    PanditStatus? status,
    List<Pandit>? pandits,
    List<String>? poojaCategories,
    String? selectedFilter,
    String? message,
  }) {
    return PanditState(
      status: status ?? this.status,
      pandits: pandits ?? this.pandits,
      poojaCategories: poojaCategories ?? this.poojaCategories,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      message: message,
    );
  }
}