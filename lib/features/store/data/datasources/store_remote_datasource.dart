import '../../../../core/widgets/app_img.dart';
import '../models/store_home_model.dart';

abstract class StoreRemoteDataSource {
  Future<StoreHomeModel> getStoreHome();
}

class StoreRemoteDataSourceImpl implements StoreRemoteDataSource {
  StoreRemoteDataSourceImpl();

  @override
  Future<StoreHomeModel> getStoreHome() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final Map<String, dynamic> response = {
      'categories': [
        {
          'id': 'cat_1',
          'name': 'Pooja Samagri',
          'image': AppImg.poojaAnushthanImg,
        },
        {
          'id': 'cat_2',
          'name': 'Idols',
          'image': AppImg.profileImg,
        },
        {
          'id': 'cat_3',
          'name': 'Rudraksha & Mala',
          'image': AppImg.mandirImg,
        },
        {
          'id': 'cat_4',
          'name': 'Books & Audio',
          'image': AppImg.sanskarImg,
        },
        {
          'id': 'cat_5',
          'name': 'Rings & Audio',
          'image': AppImg.prasadImg,
        },
      ],

      'best_selling_products': [
        {
          'id': 'p_1',
          'name': 'Puja Thali Set',
          'image': AppImg.sanskarImg,
          'price': 499,
          'original_price': 699,
          'discount_percentage': 29,
          'rating': 4.3,
          'review_count': 32,
          'category': 'Pooja Samagri',
        },
        {
          'id': 'p_2',
          'name': 'Ghanti',
          'image': AppImg.dramSevaImg,
          'price': 499,
          'original_price': 699,
          'discount_percentage': 29,
          'rating': 4.4,
          'review_count': 28,
          'category': 'Pooja Samagri',
        },
        {
          'id': 'p_3',
          'name': 'Diya Set',
          'image': AppImg.vivahSanskarImg,
          'price': 299,
          'original_price': 399,
          'discount_percentage': 25,
          'rating': 4.5,
          'review_count': 41,
          'category': 'Pooja Samagri',
        },
      ],

      'banners': [
        {
          'id': 'banner_1',
          'title': 'Bring Divinity Home',
          'subtitle': 'Pooja essentials, spiritual products and more.',
          'image': AppImg.prasadImg,
          'button_text': 'Shop Now',
        },
        {
          'id': 'banner_2',
          'title': 'Sacred Essentials',
          'subtitle': 'For Everyday Life',
          'image': AppImg.vivahSanskarImg,
          'button_text': 'Explore',
        },
      ],

      'shop_by_occasion': [
        {
          'id': 'occasion_1',
          'name': 'Dharmik Seva',
          'image': AppImg.dramSevaImg,
          'price': 399,
          'original_price': 599,
          'discount_percentage': 33,
          'rating': 4.2,
          'review_count': 18,
          'category': 'Occasion',
        },
        {
          'id': 'occasion_2',
          'name': 'Diwali',
          'image': AppImg.poojaAnushthanImg,
          'price': 499,
          'original_price': 699,
          'discount_percentage': 29,
          'rating': 4.5,
          'review_count': 25,
          'category': 'Occasion',
        },
      ],

      'newly_launched': [
        {
          'id': 'new_1',
          'name': 'Puja Thali Set',
          'image': AppImg.prasadImg,
          'price': 499,
          'original_price': 699,
          'discount_percentage': 29,
          'rating': 4.3,
          'review_count': 32,
          'category': 'New',
        },
        {
          'id': 'new_2',
          'name': 'Ghanti',
          'image': AppImg.prasadImg,
          'price': 499,
          'original_price': 699,
          'discount_percentage': 29,
          'rating': 4.4,
          'review_count': 28,
          'category': 'New',
        },
      ],

      'best_sellers': [
        {
          'id': 'best_1',
          'name': 'Dhamru',
          'image': AppImg.prasadImg,
          'price': 499,
          'original_price': 699,
          'discount_percentage': 29,
          'rating': 4.6,
          'review_count': 54,
          'category': 'Best Seller',
        },
        {
          'id': 'best_2',
          'name': 'Rudraksha Mala',
          'image': AppImg.prasadImg,
          'price': 499,
          'original_price': 699,
          'discount_percentage': 29,
          'rating': 4.7,
          'review_count': 76,
          'category': 'Best Seller',
        },
        {
          'id': 'best_3',
          'name': 'Ganesha Murti',
          'image': AppImg.prasadImg,
          'price': 699,
          'original_price': 899,
          'discount_percentage': 22,
          'rating': 4.8,
          'review_count': 63,
          'category': 'Best Seller',
        },
      ],

      'murti_and_mala': [
        {
          'id': 'murti_1',
          'name': 'Shivling',
          'image': AppImg.prasadImg,
          'price': 499,
          'original_price': 699,
          'discount_percentage': 29,
          'rating': 4.5,
          'review_count': 30,
          'category': 'Murti',
        },
        {
          'id': 'murti_2',
          'name': 'Ganesha Murti',
          'image': AppImg.prasadImg,
          'price': 699,
          'original_price': 899,
          'discount_percentage': 22,
          'rating': 4.8,
          'review_count': 63,
          'category': 'Murti',
        },
      ],
    };
    return StoreHomeModel.fromJson(response);
  }
}
