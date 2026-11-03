import 'dart:math';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_remote_datasource.dart';
import '../models/wishlist_item_model.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource remoteDataSource;
  WishlistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<WishlistItem>>> getWishlist() async {
    try {
      final items = await remoteDataSource.getWishlist();
      return Right(items);
    } catch (_) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToWishlist(WishlistItem item) async {
    try {
      final model = WishlistItemModel(
        id: item.id,
        productId: item.productId,
        name: item.name,
        image: item.image,
        price: item.price,
        originalPrice: item.originalPrice,
        category: item.category,
        inStock: item.inStock,
      );

      await remoteDataSource.addToWishlist(model);
      return const Right(null);
    } catch (_) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(String productId) async {
    try {
      await remoteDataSource.removeFromWishlist(productId);
      return const Right(null);
    } catch (_) {
      return Left(ServerFailure(e.toString()));
    }
  }
}



