import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/wishlist_item.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<WishlistItem>>> getWishlist();
  Future<Either<Failure, void>> addToWishlist(WishlistItem item);
  Future<Either<Failure, void>> removeFromWishlist(String productId);
}
