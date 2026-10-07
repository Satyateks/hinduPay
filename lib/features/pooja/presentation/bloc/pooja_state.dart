import 'package:equatable/equatable.dart';

import '../../domain/entities/pooja.dart';

enum PoojaStatus { initial, loading, success, failure }

class PoojaState extends Equatable {
  final PoojaStatus status;
  final List<Pooja> poojas;
  final Pooja? selectedPooja;
  final List<String> categories;
  final String? errorMessage;

  const PoojaState({
    this.status = PoojaStatus.initial,
    this.poojas = const [],
    this.selectedPooja,
    this.categories = const [],
    this.errorMessage,
  });

  PoojaState copyWith({
    PoojaStatus? status,
    List<Pooja>? poojas,
    Pooja? selectedPooja,
    List<String>? categories,
    String? errorMessage,
  }) {
    return PoojaState(
      status: status ?? this.status,
      poojas: poojas ?? this.poojas,
      selectedPooja: selectedPooja ?? this.selectedPooja,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    poojas,
    selectedPooja,
    categories,
    errorMessage,
  ];
}
