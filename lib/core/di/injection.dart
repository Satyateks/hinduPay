import 'package:get_it/get_it.dart';

import '../../app/theme/theme_controller.dart';
import '../../features/auth/domain/usecases/check_auth_status.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_data.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/pandit/data/datasources/pandit_remote_datasource.dart';
import '../../features/pandit/data/repositories/pandit_repository_impl.dart';
import '../../features/pandit/domain/repositories/pandit_repository.dart';
import '../../features/pandit/domain/usecases/get_pandits.dart';
import '../../features/pandit/presentation/bloc/pandit_bloc.dart';
import '../../features/pooja/data/datasources/pooja_remote_datasource.dart';
import '../../features/pooja/data/repositories/pooja_repository_impl.dart';
import '../../features/pooja/domain/usecases/get_pooja_categories.dart';
import '../../features/pooja/domain/usecases/get_pooja_details.dart';
import '../../features/pooja/domain/usecases/get_poojas.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_user_profile.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/store/data/datasources/address_remote_datasource.dart';
import '../../features/store/data/datasources/cart_remote_datasource.dart';
import '../../features/store/data/datasources/product_remote_datasource.dart';
import '../../features/store/data/datasources/store_remote_datasource.dart';
import '../../features/store/data/repositories/address_repository_impl.dart';
import '../../features/store/data/repositories/cart_repository_impl.dart';
import '../../features/store/data/repositories/product_repository_impl.dart';
import '../../features/store/data/repositories/store_repository_impl.dart';
import '../../features/store/domain/repositories/cart_repository.dart';
import '../../features/store/domain/repositories/product_repository.dart';
import '../../features/store/domain/repositories/store_repository.dart';
import '../../features/store/domain/usecases/add_to_cart.dart';
import '../../features/store/domain/usecases/get_cart.dart';
import '../../features/store/domain/usecases/get_product_details.dart';
import '../../features/store/domain/usecases/get_store_home.dart';
import '../../features/store/domain/usecases/remove_from_cart.dart';
import '../../features/store/domain/usecases/update_cart_quantity.dart';
import '../../features/store/presentation/bloc/address/address_bloc.dart';
import '../../features/store/presentation/bloc/cart/cart_bloc.dart';
import '../../features/store/presentation/bloc/product_detail/product_detail_bloc.dart';
import '../../features/store/presentation/bloc/store_home/store_home_bloc.dart';
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
  getIt.registerLazySingleton<ThemeController>(() => ThemeController());

  // ----------------------------------------------------------
  // Auth - Data
  // ----------------------------------------------------------

  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(apiClient: getIt<ApiClient>()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>(), networkInfo: getIt<NetworkInfo>()));

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






  // ----------------------------------------------------------
  // Profile - Data
  // ----------------------------------------------------------

  getIt.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(apiClient: getIt<ApiClient>()));

  // ----------------------------------------------------------
  // Profile - Repository
  // ----------------------------------------------------------

  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(remoteDataSource: getIt<ProfileRemoteDataSource>()));

  // ----------------------------------------------------------
  // Profile - UseCase
  // ----------------------------------------------------------

  getIt.registerLazySingleton<GetProfileDetails>(() => GetProfileDetails(repository: getIt<ProfileRepository>()));

  // ----------------------------------------------------------
  // Profile - Bloc
  // ----------------------------------------------------------

  getIt.registerFactory<ProfileBloc>(() => ProfileBloc(getProfileDetails: getIt<GetProfileDetails>()));



 // ----------------------------------------------------------
  // Pooja - Data Source
  // ----------------------------------------------------------

  getIt.registerLazySingleton<PoojaRemoteDataSource>(() => PoojaRemoteDataSourceImpl(apiClient: getIt<ApiClient>()));

  // ----------------------------------------------------------
  // Pooja - Repository
  // ----------------------------------------------------------

  getIt.registerLazySingleton<PoojaRepository>(() => PoojaRepositoryImpl(remoteDataSource: getIt<PoojaRemoteDataSource>()));

  // ----------------------------------------------------------
  // Pooja - Use Cases
  // ----------------------------------------------------------

  getIt.registerLazySingleton<GetPoojas>(() => GetPoojas(getIt<PoojaRepository>()));
  getIt.registerLazySingleton<GetPoojaDetail>(() => GetPoojaDetail(getIt<PoojaRepository>()));
  getIt.registerLazySingleton<GetPoojaCategories>(() => GetPoojaCategories(getIt<PoojaRepository>()));


  // Data Source & Repository
  getIt.registerLazySingleton<PanditRemoteDataSource>(() => PanditRemoteDataSourceImpl());
  getIt.registerLazySingleton<PanditRepository>(() => PanditRepositoryImpl(remoteDataSource: getIt<PanditRemoteDataSource>()));
  // UseCase
  getIt.registerLazySingleton(() => GetPandits(repository: getIt<PanditRepository>()));
  // Bloc
  getIt.registerFactory(() => PanditBloc(getPandits: getIt<GetPandits>()));






// ----------------------------------------------------------
// Home - Data Source
// ----------------------------------------------------------

getIt.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(apiClient: getIt<ApiClient>()));

// Home - Repository
getIt.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(remoteDataSource: getIt<HomeRemoteDataSource>()));

// Home - Use Case
getIt.registerLazySingleton<GetHome>(() => GetHome(getIt<HomeRepository>()));

// Home - BLoC
getIt.registerFactory<HomeBloc>(() => HomeBloc(getHome: getIt<GetHome>()));





  // ==================== STORE ====================

  getIt.registerLazySingleton<StoreRemoteDataSource>(() => StoreRemoteDataSourceImpl());
  getIt.registerLazySingleton<StoreRepository>(() => StoreRepositoryImpl(remoteDataSource: getIt<StoreRemoteDataSource>()));
  getIt.registerLazySingleton<GetStoreHome>(() => GetStoreHome(getIt<StoreRepository>()));
  getIt.registerFactory<StoreHomeBloc>(() => StoreHomeBloc(getStoreHome: getIt<GetStoreHome>()));




  getIt.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl());
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(remoteDataSource: getIt<ProductRemoteDataSource>()));
  getIt.registerLazySingleton<GetProductDetails>(() => GetProductDetails(getIt<ProductRepository>()));
  getIt.registerFactory<ProductDetailBloc>(() => ProductDetailBloc(getProductDetails: getIt<GetProductDetails>()));
  

  getIt.registerLazySingleton<CartRemoteDataSource>(() => CartRemoteDataSourceImpl());
  getIt.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(remoteDataSource: getIt<CartRemoteDataSource>()));

  getIt.registerLazySingleton<GetCart>(() => GetCart(getIt<CartRepository>()));
  getIt.registerLazySingleton<AddToCart>(() => AddToCart(getIt<CartRepository>()));
  getIt.registerLazySingleton<UpdateCartQuantity>(() => UpdateCartQuantity(getIt<CartRepository>()));
  getIt.registerLazySingleton<RemoveFromCart>(() => RemoveFromCart(getIt<CartRepository>()));
  getIt.registerFactory<CartBloc>(
    () => CartBloc(
      getCart: getIt<GetCart>(),
      addToCart: getIt<AddToCart>(),
      updateCartQuantity: getIt<UpdateCartQuantity>(),
      removeFromCart: getIt<RemoveFromCart>(),
    ),
  );





  getIt.registerLazySingleton<AddressRemoteDataSource>(() => AddressRemoteDataSourceImpl());
  getIt.registerLazySingleton<AddressRepository>(() => AddressRepositoryImpl(remoteDataSource: getIt<AddressRemoteDataSource>()));
  getIt.registerFactory<AddressBloc>(() => AddressBloc(repository: getIt<AddressRepository>()));



}




