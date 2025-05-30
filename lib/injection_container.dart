import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hatley/core/network.dart';
import 'package:hatley/data/datasources/addOrder_datasource/add_order_datasource_impl.dart';
import 'package:hatley/data/datasources/addOrder_datasource/add_order_remote_datasource.dart';
import 'package:hatley/data/datasources/getAllGovernorate_datasource/get_all_governorate_datasource_impl.dart';
import 'package:hatley/data/datasources/getAllGovernorate_datasource/get_all_governorate_remote_datasource.dart';
import 'package:hatley/data/datasources/getAllOrders_datasource/getAll_orders_datasource_impl.dart';
import 'package:hatley/data/datasources/getAllOrders_datasource/getAll_orders_remote_datasource.dart';
import 'package:hatley/data/datasources/getAllZoneById_datasource/get_all_zoneBy_gov_name_datasource_impl.dart';
import 'package:hatley/data/datasources/getAllZoneById_datasource/get_all_zoneBy_gov_name_remote_datasource.dart';
import 'package:hatley/data/datasources/logout_datasource/logout_datasource_impl.dart';
import 'package:hatley/data/datasources/logout_datasource/logout_remote_datasource.dart';
import 'package:hatley/data/datasources/signIn_datasource/signIn_datasource_impl.dart';
import 'package:hatley/data/datasources/signIn_datasource/signIn_remote_datasource.dart';
import 'package:hatley/data/repo_impl/location_repo_impl.dart';
import 'package:hatley/data/repo_impl/order_repo_impl.dart';
import 'package:hatley/domain/repo/location_repo.dart';
import 'package:hatley/domain/repo/order_repo.dart';
import 'package:hatley/domain/usecases/addOrder_usecase.dart';
import 'package:hatley/domain/usecases/getAllGovernorate_usecase.dart';
import 'package:hatley/domain/usecases/getAllOrders_usecase.dart';
import 'package:hatley/domain/usecases/getAllZoneByGovName_usecase.dart';
import 'package:hatley/domain/usecases/logout_usecase.dart';
import 'package:hatley/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:hatley/presentation/cubit/governorate_cubit/governorate_cubit.dart';
import 'package:hatley/presentation/cubit/order_cubit/getAllOrders_cubit.dart';
import 'package:hatley/presentation/cubit/order_cubit/order_cubit.dart';
import 'package:hatley/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:hatley/data/datasources/register_datasource/register_data_source_impl.dart';
import 'package:hatley/data/datasources/register_datasource/register_remote_datasource.dart';
import 'package:hatley/data/repo_impl/user_repo_impl.dart';
import 'package:hatley/domain/repo/user_repo.dart';
import 'package:hatley/domain/usecases/register_usecase.dart';
import 'package:hatley/presentation/cubit/zone_cubit/zone_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/local/token_storage.dart';
import 'domain/usecases/signIn_usecase.dart';

final sl = GetIt.instance;

Future<void> setupGetIt() async {
  // ✅ SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // ✅ TokenStorage
  sl.registerLazySingleton<TokenStorage>(() => TokenStorageImpl(sl()));

  // ✅ Dio (Async)
  sl.registerLazySingletonAsync<Dio>(() async => await DioFactory.createDio());

  // ✅ تأكد من انتظار Dio قبل استدعاء باقي الـ dependencies
  await sl.isReady<Dio>();

  // ✅ Data Sources
  sl.registerLazySingleton<RegisterRemoteDataSource>(
    () => RegisterDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<SignInRemoteDataSource>(
    () => SignInDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<LogOutRemoteDatasource>(
    () => LogOutDatasourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<GetAllGovernorateRemoteDataSource>(
    () => GetAllGovernorateDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<GetAllZoneByGovNameRemoteDataSource>(
    () => GetAllZoneByGovNameDatasourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<AddOrderRemoteDatasource>(
    () => AddOrderDatasourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<GetAllOrdersRemoteDataSource>(
    () => GetallOrdersDatasourceImpl(dio: sl()),
  );

  // ✅ Repositories
  sl.registerLazySingleton<UserRepo>(() => UserRepoImpl(sl(), sl(), sl()));
  sl.registerLazySingleton<LocationRepo>(() => LocationRepoImpl(sl(), sl()));
  sl.registerLazySingleton<OrderRepo>(() => OrderRepoImpl(sl(), sl()));

  // ✅ UseCases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl(), sl()));
  sl.registerLazySingleton(() => LogOutUseCase(sl()));
  sl.registerLazySingleton(() => GetAllGovernorateUseCase(sl()));
  sl.registerLazySingleton(() => GetAllZoneByGovNameUseCase(sl()));
  sl.registerLazySingleton(() => AddorderUsecase(sl()));
  sl.registerLazySingleton(() => GetallordersUseCase(sl()));

  // ✅ Cubits
  sl.registerFactory(() => RegisterCubit(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl(), sl()));
  sl.registerFactory(() => GovernorateCubit(sl()));
  sl.registerFactory(() => ZoneCubit(sl()));
  sl.registerFactory(() => OrderCubit(sl()));
  sl.registerFactory(() => GetAllOrdersCubit(sl()));

  // ✅ تأكد أن كل شيء أصبح جاهزًا
  await sl.allReady();
}
