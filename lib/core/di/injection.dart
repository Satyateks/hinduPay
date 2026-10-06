import 'package:get_it/get_it.dart';

import '../../features/auth/domain/usecases/check_auth_status.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // ----------------------------------------------------------
  // Core
  // ----------------------------------------------------------

  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfo());

  // ----------------------------------------------------------
  // Auth - Data
  // ----------------------------------------------------------

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // ----------------------------------------------------------
  // Auth - Domain
  // ----------------------------------------------------------

  getIt.registerLazySingleton(() => CheckAuthStatus(repository: getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => Login(repository: getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => VerifyOtp(repository: getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => Logout(repository: getIt<AuthRepository>()));


    // ----------------------------------------------------------
  // Bloc (Saari dependencies yahan pass karein)
  // ----------------------------------------------------------
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      login: getIt<Login>(),
      verifyOtp: getIt<VerifyOtp>(),
      logout: getIt<Logout>(),
      checkAuthStatus: getIt<CheckAuthStatus>(),
    ),
  );

}




