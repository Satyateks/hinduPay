import 'package:equatable/equatable.dart';

abstract class StoreHomeEvent extends Equatable {
  const StoreHomeEvent();
  @override
  List<Object?> get props => [];
}

class LoadStoreHome extends StoreHomeEvent {
  const LoadStoreHome();
}

class RefreshStoreHome extends StoreHomeEvent {
  const RefreshStoreHome();
}
