import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hatley/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:hatley/presentation/cubit/make_orders_cubit/make_orders_cubit.dart';
import 'package:hatley/presentation/cubit/navigation_cubit.dart';
import 'presentation/cubit/tracking_cubit/tracking_cubit.dart';
import 'core/local/token_storage.dart';
import 'core/routes_manager.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  await setupGetIt();

  final tokenStorage = sl<TokenStorage>();
  final token = await tokenStorage.getToken();
  final expirationStr = await tokenStorage.getExpiration();

  String initialRoute;

  if (token != null && expirationStr != null) {
    final expiration = DateTime.tryParse(expirationStr);
    final now = DateTime.now().toUtc();
    if (expiration != null && now.isBefore(expiration)) {
      initialRoute = RoutesManager.homeRoute;
    } else {
      await tokenStorage.clearToken();
      initialRoute = RoutesManager.splashRoute;
    }
  } else {
    initialRoute = RoutesManager.splashRoute;
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 912),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NavigationCubit()),
          BlocProvider(create: (context) => sl<MakeOrderCubit>()),
          BlocProvider(create: (context) => sl<AuthCubit>()),
          BlocProvider(create: (context) => sl<TrackingCubit>()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RoutesManager.router,
          initialRoute: initialRoute,
        ),
      ),
    );
  }
}
