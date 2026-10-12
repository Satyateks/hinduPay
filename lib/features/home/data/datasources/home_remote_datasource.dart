import 'package:hindu_pay/core/widgets/app_img.dart';

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
          'image': AppImg.ramMandirImg,
          'location': 'Ayodhya, UP',
        },
        {
          'id': 't2',
          'name': 'Kashi Vishwanath',
          'image': AppImg.kashiVvishnathImg,
          'location': 'Varanasi, UP',
        },
        {
          'id': 't3',
          'name': 'Somnath Temple',
          'image': AppImg.triveniMandirImg,
          'location': 'Gujarat',
        },
      ],

      'causes': [
        {
          'id': 'c1',
          'title': 'Support Temple Seva',
          'image': AppImg.triveniMandirImg,
          'target_amount': 100000,
          'collected_amount': 65000,
        },
      ],

      'astrology': {
        'title': 'Know Your Destiny',
        'subtitle': 'Get personalized astrology guidance',
        'image': AppImg.triveniMandirImg,
      },

      'poojas': [
        {
          'id': 'p1',
          'name': 'Satyanarayan Puja',
          'image': AppImg.ramMandirImg,
          'price': 1500,
        },
        {
          'id': 'p2',
          'name': 'Rudrabhishek',
          'image':AppImg.kashiVvishnathImg,
          'price': 1800,
        },
        {
          'id': 'p3',
          'name': 'Griha Pravesh',
          'image': AppImg.triveniMandirImg,
          'price': 2500,
        },
      ],

      'upcoming_activities': [
        {
          'id': 'a1',
          'title': 'Navratri Puja',
          'date': '2026-10-15',
          'image':AppImg.poojaAnushthanImg,
        },
      ],

      'recommendations': [
        {
          'id': 'r1',
          'title': 'Book a Pandit',
          'image': AppImg.panditjiImg,
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
