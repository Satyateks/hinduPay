import 'package:hindu_pay/core/widgets/app_img.dart';

import '../models/card_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart();
  Future<CartModel> addToCart({required String productId,required int quantity});
  Future<CartModel> updateQuantity({required String cartItemId,required int quantity});
  Future<CartModel> removeFromCart({required String cartItemId});
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  CartRemoteDataSourceImpl();

  final List<Map<String, dynamic>> _items = [
    {
      'id': 'cart_1',
      'product_id': 'p_1',
      'name': 'Puja Thali Set',
      'image': AppImg.pujaThaliImg,
      'price': 499,
      'original_price': 699,
      'quantity': 2,
    },
    {
      'id': 'cart_2',
      'product_id': 'p_2',
      'name': 'Ghanti',
      'image': AppImg.ghantiImg,
      'price': 299,
      'original_price': 399,
      'quantity': 1,
    },
    {
      'id': 'cart_3',
      'product_id': 'p_3',
      'name': 'Dhamru',
      'image': AppImg.damruImg,
      'price': 200,
      'original_price': 250,
      'quantity': 4,
    },
  ];


  @override
  Future<CartModel> getCart() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _dummyCart();
  }


  @override
  Future<CartModel> addToCart({
    required String productId,
    required int quantity,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final existingIndex = _items.indexWhere((item) => item['product_id'] == productId);

    // ignore: curly_braces_in_flow_control_structures
    if (existingIndex != -1) _items[existingIndex]['quantity'] =(_items[existingIndex]['quantity'] as int) + quantity;
    else {
      _items.add({
        'id': 'cart_${DateTime.now().millisecondsSinceEpoch}',
        'product_id': productId,
        'name': 'New Product',
        'image': 'assets/images/store/product.png',
        'price': 999,
        'original_price': 1299,
        'quantity': quantity,
      });
    }
    return _dummyCart();
  }

  @override
  Future<CartModel> updateQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _items.indexWhere((item) => item['id'] == cartItemId);
    if (index != -1)_items[index]['quantity'] = quantity;
    return _dummyCart();
  }

  @override
  Future<CartModel> removeFromCart({required String cartItemId}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _items.removeWhere((item) => item['id'] == cartItemId);
    return _buildCart();
  }

  CartModel _dummyCart() {
    return CartModel.fromJson({
      'items': [
        {
          'id': 'cart_1',
          'product_id': 'p_1',
          'name': 'Puja Thali Set',
          'image': AppImg.prasadImg,
          'price': 499,
          'original_price': 699,
          'quantity': 1,
        },
        {
          'id': 'cart_2',
          'product_id': 'p_2',
          'name': 'Ghanti',
          'image': AppImg.prasadImg,
          'price': 299,
          'original_price': 399,
          'quantity': 1,
        },
      ],
      'delivery_address': {
        'id': 'address_1',
        'name': 'Rahul Sharma',
        'phone': '98XXXXXX10',
        'address': 'Techzone 4, Greater Noida',
        'city': 'Greater Noida',
        'state': 'Uttar Pradesh',
        'pincode': '201310',
      },
      'subtotal': 798,
      'discount': 200,
      'delivery_charge': 0,
      'coupon_discount': 50,
      'total': 548,
    });
  }

    CartModel _buildCart() {
    double subtotal = 0;
    double discount = 0;

    for (final item in _items) {
      final price = (item['price'] as num).toDouble();
      final originalPrice = (item['original_price'] as num).toDouble();
      final quantity = item['quantity'] as int;
      subtotal += price * quantity;
      discount +=(originalPrice - price) * quantity;
    }

    const double deliveryCharge = 0;
    const double couponDiscount = 10;
    final total =subtotal - discount - couponDiscount + deliveryCharge;

    return CartModel.fromJson({
      'items': _items,
      'delivery_address': {
        'id': 'address_1',
        'name': 'Rahul Sharma',
        'phone': '98XXXXXX10',
        'address': 'Techzone 4, Greater Noida',
        'city': 'Greater Noida',
        'state': 'Uttar Pradesh',
        'pincode': '201310',
      },
      'subtotal': subtotal,
      'discount': discount,
      'delivery_charge': deliveryCharge,
      'coupon_discount': couponDiscount,
      'total': total,
    });
  }


}
 
