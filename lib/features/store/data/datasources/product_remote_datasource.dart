import '../../../../core/widgets/app_img.dart';
import '../models/product_detail_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductDetailModel> getProductDetails(String productId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl();

  @override
  Future<ProductDetailModel> getProductDetails(String productId) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final Map<String, dynamic> response = {
      'id': productId,
      'name': 'Puja Thali Set',

      'description':
          'Lorem ipsum dolor sit amet consectetur. '
          'Premium traditional puja thali set for your '
          'daily puja and special occasions.',

      'images': [
        AppImg.prasadImg,
        AppImg.prasadImg,
        AppImg.prasadImg,
        AppImg.prasadImg,
      ],

      'price': 499,
      'original_price': 699,
      'discount_percentage': 29,

      'rating': 4.3,
      'review_count': 32,

      'included_items': [
        {
          'id': 'item_1',
          'name': 'Puja Thali',
          'image': AppImg.prasadImg,
          'quantity': '1 Pc',
        },
        {
          'id': 'item_2',
          'name': 'Kalash',
          'image': AppImg.prasadImg,
          'quantity': '1 Pc',
        },
        {
          'id': 'item_3',
          'name': 'Diya',
          'image': AppImg.prasadImg,
          'quantity': '1 Pc',
        },
        {
          'id': 'item_4',
          'name': 'Agarbatti Stand',
          'image': AppImg.prasadImg,
          'quantity': '1 Pc',
        },
        {
          'id': 'item_5',
          'name': 'Chandan Bowl',
          'image': AppImg.prasadImg,
          'quantity': '1 Pc',
        },
      ],

      'product_information': {
        'material': 'Pure Brass',
        'finish': 'Traditional Polish',
        'diameter': '10 Inches',
        'usage': 'Daily Puja, Festivals, Gifting',
        'weight': 'Approx. 850 g',
        'packaging': 'Safe & Secure Packaging',
      },

      'delivery_information': {
        'delivery_text': 'Pan India Delivery',
        'return_text': 'Easy Returns',
        'trusted_text': 'Trusted by 1 Lakh+ Devotees',
      },

      'recommended_products': [
        {
          'id': 'rec_1',
          'name': 'Puja Thali Set',
          'image':AppImg.prasadImg,
          'price': 499,
          'original_price': 699,
          'discount_percentage': 29,
          'rating': 4.3,
          'review_count': 32,
        },
        {
          'id': 'rec_2',
          'name': 'Ghanti',
          'image': AppImg.prasadImg,
          'price': 499,
          'original_price': 699,
          'discount_percentage': 29,
          'rating': 4.4,
          'review_count': 28,
        },
        {
          'id': 'rec_3',
          'name': 'Rudraksha Mala',
          'image':AppImg.prasadImg,
          'price': 499,
          'original_price': 699,
          'discount_percentage': 29,
          'rating': 4.7,
          'review_count': 76,
        },
      ],
    };

    return ProductDetailModel.fromJson(response);
  }
}
