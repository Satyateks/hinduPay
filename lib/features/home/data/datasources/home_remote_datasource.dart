
import '../../../../core/network/api_client.dart';

class HomeRemoteDataSource {
  final ApiClient apiClient;
  HomeRemoteDataSource({required this.apiClient});
  Future<Map<String, dynamic>> getHomeData() async {
    final response = await apiClient.get('/home');
    return Map<String, dynamic>.from(response.data['data'] ?? {});
  }
}
