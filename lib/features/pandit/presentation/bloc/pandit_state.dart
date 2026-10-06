// State
import '../../domain/entities/pandit.dart';

enum PanditStatus { initial, loading, loaded, failure }

class PanditState {
  final PanditStatus status;
  final List<Pandit> pandits;
  final String? message;

  const PanditState({
    this.status = PanditStatus.initial,
    this.pandits = const [],
    this.message,
  });

  PanditState copyWith({
    PanditStatus? status,
    List<Pandit>? pandits,
    String? message,
  }) {
    return PanditState(
      status: status ?? this.status,
      pandits: pandits ?? this.pandits,
      message: message,
    );
  }
}
