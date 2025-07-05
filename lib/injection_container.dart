import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hatley/data/datasources/deliveries_datasource.dart';
import 'package:hatley/data/datasources/profile_datasource.dart';
import 'package:hatley/data/repo_impl/deliveries_repo_impl.dart';
import 'package:hatley/data/repo_impl/profile_repo_impl.dart';
import 'package:hatley/domain/repo/deliveries_repo.dart';
import 'package:hatley/domain/repo/profile_repo.dart';
import 'package:hatley/domain/usecases/change_passwoed_usecase.dart';
import 'package:hatley/domain/usecases/getAll_statistics_usecase.dart';
import 'package:hatley/domain/usecases/get_deliveries_usecase.dart';
import 'package:hatley/domain/usecases/get_profile_info_usecase.dart';
import 'package:hatley/domain/usecases/updateProfile_usecase.dart';
import 'package:hatley/domain/usecases/upload_profile_img_usecase.dart';
import 'package:hatley/presentation/cubit/change_pass_cubit/change_pass_cubit.dart';
import 'package:hatley/presentation/cubit/deliveries_cubit/deliveries_cubit.dart';
import 'package:hatley/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:hatley/presentation/cubit/statistics_cubit/statistics_cubit.dart';
import 'package:hatley/presentation/cubit/tracking_cubit/tracking_cubit.dart';
import 'package:hatley/core/network.dart';
import 'package:hatley/data/datasources/offer_datasource.dart';
import 'package:hatley/data/datasources/add_order_datasource.dart';
import 'package:hatley/data/datasources/delete_order_datasource.dart';
import 'package:hatley/data/datasources/edit_order_datasource.dart';
import 'package:hatley/data/datasources/get_all_governorate_datasource.dart';
import 'package:hatley/data/datasources/getAll_orders_datasource.dart';
import 'package:hatley/data/datasources/get_all_zoneBy_gov_name_datasource.dart';
import 'package:hatley/data/datasources/logout_remote_datasource.dart';
import 'package:hatley/data/datasources/signIn_datasource.dart';
import 'package:hatley/data/repo_impl/location_repo_impl.dart';
import 'package:hatley/data/repo_impl/offer_repo_impl.dart';
import 'package:hatley/data/repo_impl/order_repo_impl.dart';
import 'package:hatley/domain/repo/location_repo.dart';
import 'package:hatley/domain/repo/offer_repo.dart';
import 'package:hatley/domain/repo/order_repo.dart';
import 'package:hatley/domain/usecases/acceptOffer_usecase.dart';
import 'package:hatley/domain/usecases/addOrder_usecase.dart';
import 'package:hatley/domain/usecases/declineOffer_usecase.dart';
import 'package:hatley/domain/usecases/deleteOrder_usecase.dart';
import 'package:hatley/domain/usecases/editOrder_usecase.dart';
import 'package:hatley/domain/usecases/getAllGovernorate_usecase.dart';
import 'package:hatley/domain/usecases/getAllOrders_usecase.dart';
import 'package:hatley/domain/usecases/getAllZoneByGovName_usecase.dart';
import 'package:hatley/domain/usecases/logout_usecase.dart';
import 'package:hatley/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:hatley/presentation/cubit/edit_order_cubit/edit_order_cubit.dart';
import 'package:hatley/presentation/cubit/governorate_cubit/governorate_cubit.dart';
import 'package:hatley/presentation/cubit/make_orders_cubit/make_orders_cubit.dart';
import 'package:hatley/presentation/cubit/offer_cubit/offer_cubit.dart';
import 'package:hatley/presentation/cubit/order_cubit/delete_order_cubit.dart';
import 'package:hatley/presentation/cubit/order_cubit/getAllOrders_cubit.dart';
import 'package:hatley/presentation/cubit/order_cubit/add_order_cubit.dart';
import 'package:hatley/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:hatley/data/datasources/register_datasource.dart';
import 'package:hatley/data/repo_impl/user_repo_impl.dart';
import 'package:hatley/domain/repo/user_repo.dart';
import 'package:hatley/domain/usecases/register_usecase.dart';
import 'package:hatley/presentation/cubit/zone_cubit/zone_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api_manager/api_manager.dart';
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
  sl.registerLazySingleton<DeleteOrderRemoteDataSource>(
    () => DeleteOrderDatasourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<EditOrderRemoteDataSource>(
    () => EditOrderDatasourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<OfferDataSource>(
    () => OfferDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<ProfileDatasource>(
    () => ProfileDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<DeliveriesDataSource>(
    () => DeliveriesDataSourceImpl(sl()),
  );

  // ✅ Repositories
  sl.registerLazySingleton<UserRepo>(() => UserRepoImpl(sl(), sl(), sl()));
  sl.registerLazySingleton<LocationRepo>(() => LocationRepoImpl(sl(), sl()));
  sl.registerLazySingleton<OrderRepo>(
    () => OrderRepoImpl(sl(), sl(), sl(), sl()),
  );
  sl.registerLazySingleton<OfferRepo>(() => OfferRepoImpl(sl()));
  sl.registerLazySingleton<ProfileRepo>(() => ProfileRepoImpl(sl()));
  sl.registerLazySingleton<DeliveriesRepo>(() => DeliveriesRepoImpl(sl()));

  // ✅ UseCases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl(), sl()));
  sl.registerLazySingleton(() => LogOutUseCase(sl()));
  sl.registerLazySingleton(() => GetAllGovernorateUseCase(sl()));
  sl.registerLazySingleton(() => GetAllZoneByGovNameUseCase(sl()));
  sl.registerLazySingleton(() => AddOrderUseCase(sl()));
  sl.registerLazySingleton(() => GetallordersUseCase(sl()));
  sl.registerLazySingleton(() => DeleteOrderUsecase(sl()));
  sl.registerLazySingleton(() => EditOrderUseCase(sl()));
  sl.registerLazySingleton(() => AcceptOfferUseCase(sl()));
  sl.registerLazySingleton(() => DeclineofferUsecase(sl()));
  sl.registerLazySingleton(() => GetProfileInfoUsecase(sl()));
  sl.registerLazySingleton(() => UploadProfileImgUsecase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUsecase(sl()));
  sl.registerLazySingleton(() => UpdateprofileUsecase(sl()));
  sl.registerLazySingleton(() => GetDeliveriesUsecase(sl()));
  sl.registerLazySingleton(() => GetallStatisticsUsecase(sl()));

  // ✅ Cubits
  sl.registerFactory(() => RegisterCubit(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl(), sl()));
  sl.registerFactory(() => GovernorateCubit(sl()));
  sl.registerFactory(() => ZoneCubit(sl()));
  sl.registerFactory(() => AddOrderCubit(sl()));
  sl.registerFactory(() => GetAllOrdersCubit(sl()));
  sl.registerFactory(() => MakeOrderCubit());
  sl.registerFactory(() => DeleteOrderCubit(sl()));
  sl.registerFactory(() => EditOrderCubit(sl()));
  sl.registerFactory(() => OfferCubit(sl(), sl()));
  sl.registerFactory(() => TrackingCubit(trakingApiManager: sl()));
  sl.registerLazySingleton<TrakingApiManager>(
    () => TrakingApiManager(dio: sl()),
  );
  sl.registerFactory(
    () => ProfileCubit(
      getProfileInfoUseCase: sl(),
      uploadProfileImgUsecase: sl(),
      updateProfileUsecase: sl(),
    ),
  );
  sl.registerFactory(() => ChangePassCubit(sl()));
  sl.registerFactory(() => DeliveriesCubit(sl()));
  sl.registerFactory(() => StatisticsCubit(sl()));

  await sl.allReady();
}
