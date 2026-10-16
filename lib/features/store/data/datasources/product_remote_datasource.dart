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
      'name': 'Premium Brass Puja Thali Set',
      'description':'Bring home divine elegance with this premium brass ''puja thali set. Perfect for daily worship, festivals, ' 'aarti, and special religious occasions.',
      'images': [
        AppImg.pujaThaliImg,
        AppImg.damruImg,
        AppImg.sacredBannerImg,
        AppImg.diyaImg,
      ],

      'price': 499,
      'original_price': 699,
      'discount_percentage': 29,
      'rating': 4.5,
      'review_count': 128,
      'included_items': [
        {
          'id': 'item_1',
          'name': 'Brass Puja Thali',
          'image': AppImg.pujaThaliImg,
          'quantity': '1 Pc',
        },
        {
          'id': 'item_2',
          'name': 'Brass Kalash',
          'image': AppImg.damruImg,
          'quantity': '1 Pc',
        },
        {
          'id': 'item_3',
          'name': 'Brass Diya',
          'image': AppImg.gangajalImg,
          'quantity': '2 Pcs',
        },
        {
          'id': 'item_4',
          'name': 'Agarbatti Stand',
          'image': AppImg.ghantiImg,
          'quantity': '1 Pc',
        },
        {
          'id': 'item_5',
          'name': 'Chandan Bowl',
          'image': AppImg.diyaImg,
          'quantity': '1 Pc',
        },
        {
          'id': 'item_6',
          'name': 'Puja Bell',
          'image': AppImg.yatraImg,
          'quantity': '1 Pc',
        },
      ],

      'product_information': {
        'material': 'Brass',
        'finish': 'Premium Golden Polish',
        'diameter': '10 Inches',
        'usage': 'Daily Puja, Aarti, Festivals, Gifting',
        'weight': 'Approx. 850 g',
        'packaging': 'Secure Protective Packaging',
      },

      'delivery_information': {
        'delivery_text': 'Delivery Across India',
        'return_text': 'Easy Returns',
        'trusted_text': 'Trusted by Devotees',
      },

      'recommended_products': [
        {
          'id': 'rec_1',
          'name': 'Brass Puja Bell',
          'image':AppImg.damruImg,
          'price': 499,
          'original_price': 699,
          'discount_percentage': 29,
          'rating': 4.3,
          'review_count': 32,
        },
        {
          'id': 'rec_2',
          'name': 'Brass Diya Set',
          'image': AppImg.diyaImg,
          'price': 249,
          'original_price': 349,
          'discount_percentage': 29,
          'rating': 4.6,
          'review_count': 104,
        },
        {
          'id': 'rec_3',
          'name': 'Rudraksha Mala',
          'image': AppImg.ghantiImg,
          'price': 299,
          'original_price': 399,
          'discount_percentage': 25,
          'rating': 4.7,
          'review_count': 176,
        },
      ],
    };
    
    return ProductDetailModel.fromJson(response);
  }
}
