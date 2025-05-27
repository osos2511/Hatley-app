import 'package:get_it/get_it.dart';
import 'package:hatley/core/network.dart';
import 'package:hatley/data/datasources/getAllGovernorate_datasource/get_all_governorate_datasource_impl.dart';
import 'package:hatley/data/datasources/getAllGovernorate_datasource/get_all_governorate_remote_datasource.dart';
import 'package:hatley/data/datasources/logout_datasource/logout_datasource_impl.dart';
import 'package:hatley/data/datasources/logout_datasource/logout_remote_datasource.dart';
import 'package:hatley/data/datasources/signIn_datasource/signIn_datasource_impl.dart';
import 'package:hatley/data/datasources/signIn_datasource/signIn_remote_datasource.dart';
import 'package:hatley/data/repo_impl/location_repo_impl.dart';
import 'package:hatley/domain/repo/location_repo.dart';
import 'package:hatley/domain/usecases/getAllGovernorate_usecase.dart';
import 'package:hatley/domain/usecases/logout_usecase.dart';
import 'package:hatley/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:hatley/presentation/cubit/location_cubit/location_cubit.dart';
import 'package:hatley/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:hatley/data/datasources/register_datasource/register_data_source_impl.dart';
import 'package:hatley/data/datasources/register_datasource/register_remote_datasource.dart';
import 'package:hatley/data/repo_impl/user_repo_impl.dart';
import 'package:hatley/domain/repo/user_repo.dart';
import 'package:hatley/domain/usecases/register_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/local/token_storage.dart';
import 'domain/usecases/signIn_usecase.dart';

final sl = GetIt.instance;

Future<void> setupGetIt() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton<TokenStorage>(() => TokenStorageImpl(sl()));

  sl.registerLazySingleton(() => DioFactory.createDio());

  // Data Sources
  sl.registerLazySingleton<RegisterRemoteDataSource>(
        () => RegisterDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<SignInRemoteDataSource>(
        () => SignInDataSourceImpl(dio: sl()),
  );
  
  sl.registerLazySingleton<LogOutRemoteDatasource>(
      ()=>LogOutDatasourceImpl(dio: sl())
  );
  sl.registerLazySingleton<GetAllGovernorateRemoteDataSource>(
      ()=>GetAllGovernorateDataSourceImpl(dio:sl())
  );

  // Repository
  sl.registerLazySingleton<UserRepo>(() => UserRepoImpl(sl(), sl(),sl()));
  sl.registerLazySingleton<LocationRepo>(() => LocationRepoImpl(sl()));

  // UseCases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl(), sl()));
  sl.registerLazySingleton(() => LogOutUseCase(sl()));
  sl.registerLazySingleton(() => GetAllGovernorateUseCase(sl()));


  // Cubits
  sl.registerFactory(() => RegisterCubit(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl(),sl()));
  sl.registerFactory(() => LocationCubit(sl()));

}
