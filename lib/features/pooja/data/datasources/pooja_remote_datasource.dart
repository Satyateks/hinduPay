import '../../../../core/network/api_client.dart';
import '../../domain/entities/pooja.dart';
import '../models/pooja_model.dart';

abstract class PoojaRepository {
  Future<List<Pooja>> getPoojas();
  Future<Pooja> getPoojaDetail(String id);
  Future<List<String>> getCategories();
}

abstract class PoojaRemoteDataSource {
  Future<List<PoojaModel>> getPoojas();
  Future<PoojaModel> getPoojaDetail(String id);
  Future<List<String>> getCategories();
}

class PoojaRemoteDataSourceImpl implements PoojaRemoteDataSource {
  final ApiClient apiClient;

  PoojaRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PoojaModel>> getPoojas() async {
    final response = await apiClient.get('/poojas');

    final List data = response.data['data'] ?? [];

    return data.map((json) => PoojaModel.fromJson(json)).toList();
  }

  @override
  Future<PoojaModel> getPoojaDetail(String id) async {
    final response = await apiClient.get('/poojas/$id');

    return PoojaModel.fromJson(response.data['data']);
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await apiClient.get('/pooja/categories');

    final List data = response.data['data'] ?? [];

    return data.map((item) => item.toString()).toList();
  }
}
