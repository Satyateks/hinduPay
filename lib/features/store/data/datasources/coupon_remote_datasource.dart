import '../models/coupon_model.dart';

abstract class CouponRemoteDataSource {
  Future<List<CouponModel>> getCoupons();
}

class CouponRemoteDataSourceImpl implements CouponRemoteDataSource {
  @override
  Future<List<CouponModel>> getCoupons() async {
    // Replace this dummy response with your existing ApiClient call later.
    final response = <Map<String, dynamic>>[
      {
        'id': 'coupon_1',
        'code': 'PUJA10',
        'title': 'Get 10% OFF',
        'description': '10% off on orders above ₹500',
        'type': 'percentage',
        'value': 10,
        'min_order_value': 500,
        'max_discount': 100,
        'is_active': true,
      },
      {
        'id': 'coupon_2',
        'code': 'SEVA50',
        'title': 'Flat ₹50 OFF',
        'description': 'Save ₹50 on orders above ₹300',
        'type': 'flat',
        'value': 50,
        'min_order_value': 300,
        'max_discount': 0,
        'is_active': true,
      },
      {
        'id': 'coupon_3',
        'code': 'WELCOME',
        'title': 'Welcome Offer',
        'description': 'Flat ₹100 off on orders above ₹1,000',
        'type': 'flat',
        'value': 100,
        'min_order_value': 1000,
        'max_discount': 0,
        'is_active': true,
      },
    ];

    return response.map(CouponModel.fromJson).toList();
  }
}
