import '../models/wishlist_item_model.dart';

abstract class WishlistRemoteDataSource {
  Future<List<WishlistItemModel>> getWishlist();
  Future<void> addToWishlist(WishlistItemModel item);
  Future<void> removeFromWishlist(String productId);
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final List<WishlistItemModel> _items = [
    const WishlistItemModel(
      id: 'wish_1',
      productId: '1',
      name: 'Premium Puja Thali Set',
      image: '',
      price: 799,
      originalPrice: 999,
      category: 'Pooja Essentials',
    ),
    const WishlistItemModel(
      id: 'wish_2',
      productId: '2',
      name: 'Brass Temple Ghanti',
      image: '',
      price: 349,
      originalPrice: 449,
      category: 'Brass Items',
    ),
    const WishlistItemModel(
      id: 'wish_3',
      productId: '3',
      name: 'Brass Diya Set',
      image: '',
      price: 499,
      originalPrice: 599,
      category: 'Diyas & Lamps',
    ),
  ];

  @override
  Future<List<WishlistItemModel>> getWishlist() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_items);
  }

  @override
  Future<void> addToWishlist(WishlistItemModel item) async {
    final alreadyExists = _items.any((element) => element.productId == item.productId);
    if (!alreadyExists) _items.add(item);
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    _items.removeWhere((item) => item.productId == productId);
  }
}



