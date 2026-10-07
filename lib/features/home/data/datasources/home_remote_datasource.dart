import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> getHome();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl({ApiClient? apiClient}): _apiClient = apiClient ?? ApiClient();
  
    final ApiClient _apiClient;

  @override
  Future<HomeModel> getHome() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    final Map<String, dynamic> response = {
      'quick_actions': [
        {'id': '1', 'title': 'Daan & Seva', 'icon': 'donation'},
        {'id': '2', 'title': 'Pooja & Anushthan', 'icon': 'pooja'},
        {'id': '3', 'title': 'Pandit Ji', 'icon': 'pandit'},
        {'id': '4', 'title': 'Mandir', 'icon': 'mandir'},
        {'id': '5', 'title': 'Prasad', 'icon': 'prasad'},
        {'id': '6', 'title': 'Sanskar', 'icon': 'sanskar'},
        {'id': '7', 'title': 'Vivah Sanskar', 'icon': 'vivah'},
        {'id': '8', 'title': 'Yatra', 'icon': 'yatra'},
      ],

      'temples': [
        {
          'id': 't1',
          'name': 'Ram Mandir',
          'image': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
          'location': 'Ayodhya, UP',
        },
        {
          'id': 't2',
          'name': 'Kashi Vishwanath',
          'image': 'https://example.com/kashi.jpg',
          'location': 'Varanasi, UP',
        },
        {
          'id': 't3',
          'name': 'Somnath Temple',
          'image': 'https://example.com/somnath.jpg',
          'location': 'Gujarat',
        },
      ],

      'causes': [
        {
          'id': 'c1',
          'title': 'Support Temple Seva',
          'image': 'https://example.com/cause.jpg',
          'target_amount': 100000,
          'collected_amount': 65000,
        },
      ],

      'astrology': {
        'title': 'Know Your Destiny',
        'subtitle': 'Get personalized astrology guidance',
        'image': 'https://example.com/astrology.jpg',
      },

      'poojas': [
        {
          'id': 'p1',
          'name': 'Satyanarayan Puja',
          'image': 'https://example.com/satyanarayan.jpg',
          'price': 1500,
        },
        {
          'id': 'p2',
          'name': 'Rudrabhishek',
          'image': 'https://example.com/rudrabhishek.jpg',
          'price': 1800,
        },
        {
          'id': 'p3',
          'name': 'Griha Pravesh',
          'image': 'https://example.com/griha.jpg',
          'price': 2500,
        },
      ],

      'upcoming_activities': [
        {
          'id': 'a1',
          'title': 'Navratri Puja',
          'date': '2026-10-15',
          'image': 'https://example.com/navratri.jpg',
        },
      ],

      'recommendations': [
        {
          'id': 'r1',
          'title': 'Book a Pandit',
          'image': 'https://example.com/pandit.jpg',
          'type': 'pandit',
        },
      ],
    };

    return HomeModel.fromJson(response);
    // throw UnimplementedError();
  }

  Future<Map<String, dynamic>> getHomeData() async {
    final response = await _apiClient.post(ApiConstants.loginUrl);
    return Map<String, dynamic>.from(response.data['data'] ?? {});
  }
}
