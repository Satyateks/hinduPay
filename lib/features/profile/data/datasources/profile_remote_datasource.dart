import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/profile_modele.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModels> getProfileDetails();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProfileModels> getProfileDetails() async {
    final response = await apiClient.get(ApiConstants.profileUrlUrl);


    return ProfileModels.fromJson(response.data);
  }
}
