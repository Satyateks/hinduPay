import 'package:equatable/equatable.dart';

import '../../../domain/entities/wishlist_item.dart';

enum WishlistStatus { initial, loading, success, updating, failure }

class WishlistState extends Equatable {
  final WishlistStatus status;
  final List<WishlistItem> items;
  final String? errorMessage;

  const WishlistState({
    this.status = WishlistStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, items, errorMessage];
}
