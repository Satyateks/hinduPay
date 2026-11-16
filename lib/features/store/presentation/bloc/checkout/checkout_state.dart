import 'package:equatable/equatable.dart';

import '../../../domain/entities/store_order.dart';

enum CheckoutStatus { initial, submitting, success, failure }

class CheckoutState extends Equatable {
  final CheckoutStatus status;
  final StoreOrder? order;
  final String? errorMessage;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.order,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, order, errorMessage];
}
