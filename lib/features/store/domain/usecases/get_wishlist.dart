import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

class GetWishlist {
  final WishlistRepository repository;
  GetWishlist(this.repository);
  Future<Either<Failure, List<WishlistItem>>> call() {return repository.getWishlist();}
}


 
class AddToWishlist {
  final WishlistRepository repository;
  AddToWishlist(this.repository);
  Future<Either<Failure, void>> call(WishlistItem item) {return repository.addToWishlist(item);}
}

 
class RemoveFromWishlist {
  final WishlistRepository repository;
  RemoveFromWishlist(this.repository);
  Future<Either<Failure, void>> call(String productId) {return repository.removeFromWishlist(productId);}
}