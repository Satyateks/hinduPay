import 'package:dartz/dartz.dart';
import 'package:hindu_pay/core/network/network_info.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../domain/entities/user.dart';
import '../models/auth_response_model.dart';
import '../repositories/auth_repository_impl.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<AuthResponseModel> login({required String mobile}) async {
    final response = await apiClient.post(ApiConstants.loginUrl, data: {'username': 'emilys','password': 'emilyspass',});

    final data = response.data;
    print('Login Response: $data');

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid server response');
    }
    return AuthResponseModel.fromJson(data);
    // return UserModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<AuthResponseModel> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    final response = await apiClient.post(
      ApiConstants.verifyOtpUrl,
      data: {'mobile': mobile, 'otp': otp},
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) throw Exception('Invalid server response');
    // return UserModel.fromJson(data['data'] as Map<String, dynamic>);
    return AuthResponseModel.fromJson(data);
  }

  Future<void> logout() async {
    await apiClient.post(ApiConstants.logoutUrl);
  }
}



// Apne models, failures, aur data source ke imports yahan dalein

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  // Agar local storage (jaise SharedPreferences) use kar rahe hain, toh wo bhi yahan aayega

  AuthRepositoryImpl({required this.remoteDataSource, required NetworkInfo networkInfo});

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    try {
      await Future.delayed(const Duration(seconds: 5)); // Splash delay
    
      // LocalStorage se token read karein
      final token = await LocalStorage.read(StorageKeys.accessToken);
      if (token != null && token.isNotEmpty) {
        return const Right(true); // Logged in
      } else {
        return const Right(false); // Not logged in
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> login({required String mobile}) async {
    try {
      final authResponse  = await remoteDataSource.login(mobile: mobile);
      await LocalStorage.write(StorageKeys.accessToken, authResponse.accessToken);
      return Right(authResponse.user); // UserModel, User ki subclass honi chahiye
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    try {
      // final userModel = await remoteDataSource.verifyOtp(mobile: mobile, otp: otp);
      await Future.delayed(const Duration(seconds: 7));
      // return Right(userModel.user);
      return Right(User(id: '1', mobile: mobile, name: 'Test User'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await LocalStorage.delete(StorageKeys.accessToken);
      // Ya pura storage clear karne ke liye: await LocalStorage.clear();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}


