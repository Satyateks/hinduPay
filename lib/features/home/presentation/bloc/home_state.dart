import 'package:equatable/equatable.dart';

enum HomeModule { pooja, pandit, darshan, donation, shop }

class HomeState extends Equatable {
  final HomeModule selectedModule;
  final int bottomNavIndex;

  const HomeState({
    this.selectedModule = HomeModule.pooja,
    this.bottomNavIndex = 0,
  });

  HomeState copyWith({HomeModule? selectedModule, int? bottomNavIndex}) {
    return HomeState(
      selectedModule: selectedModule ?? this.selectedModule,
      bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
    );
  }

  @override
  List<Object?> get props => [selectedModule, bottomNavIndex];
}
