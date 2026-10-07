import 'package:equatable/equatable.dart';

abstract class PoojaEvent extends Equatable {
  const PoojaEvent();

  @override
  List<Object?> get props => [];
}

class LoadPoojas extends PoojaEvent {
  const LoadPoojas();
}

class LoadPoojaDetail extends PoojaEvent {
  final String id;

  const LoadPoojaDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadPoojaCategories extends PoojaEvent {
  const LoadPoojaCategories();
}
