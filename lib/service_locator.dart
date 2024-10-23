

import 'package:dio/dio.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'core/helpers/networking/api_constant.dart';
import 'core/helpers/networking/api_service.dart';
import 'core/helpers/sqlite_helper.dart';
import 'features/products/data/datasources/products_remote_data_source/products_remote_data_source.dart';
import 'features/products/data/repositories/products_repository.dart';
import 'features/products/domain/repositories/i_products_repository.dart';
import 'features/products/domain/usecases/get_products.dart';


final GetIt getIt = GetIt.instance;

void setupLocator() {
  //! External
  // DatabaseHelper
  getIt.registerSingleton<DatabaseHelper>(DatabaseHelper.instance);
  // NetworkInfo
  getIt.registerLazySingleton(() => InternetConnection());

  // Dio
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: ApiConstant.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    ),
  );

  // Api service
  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt()));



  //? Data sources
  getIt.registerLazySingleton<IProductsRemoteDataSource>(
      () => ProductsRemoteDataSource(getIt()));

  //? Repositories
  getIt.registerLazySingleton<IProductsRepository>(
      () => ProductsRepository(getIt()));

  //? Usecases
  getIt.registerLazySingleton(() => GetProducts(getIt()));

  //? bloc
  getIt.registerFactory(() => ProductsCubit(getIt(), getIt()));
}
