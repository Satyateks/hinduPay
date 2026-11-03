import 'package:equatable/equatable.dart';

import '../../../domain/entities/wishlist_item.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();
  @override
  List<Object?> get props => [];
}

class LoadWishlist extends WishlistEvent {
  const LoadWishlist();
}

class AddWishlistItem extends WishlistEvent {
  final WishlistItem item;
  const AddWishlistItem(this.item);
  @override
  List<Object?> get props => [item];
}

class RemoveWishlistItem extends WishlistEvent {
  final String productId;
  const RemoveWishlistItem(this.productId);
  @override
  List<Object?> get props => [productId];
}
