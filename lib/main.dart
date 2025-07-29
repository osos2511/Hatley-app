import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatley/core/colors_manager.dart';
import 'package:hatley/presentation/cubit/feedback_cubit/feedback_cubit.dart';
import 'package:hatley/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:hatley/presentation/cubit/make_orders_cubit/make_orders_cubit.dart';
import 'package:hatley/presentation/cubit/navigation_cubit.dart';
import 'presentation/cubit/tracking_cubit/tracking_cubit.dart';
import 'core/local/token_storage.dart';
import 'core/routes_manager.dart';
import 'injection_container.dart';
import 'package:hatley/l10n/app_localizations.dart';
import 'package:hatley/core/app_state.dart';
import 'package:hatley/presentation/cubit/theme_cubit.dart';
import 'core/local/language_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  // قراءة اللغة المحفوظة
  final savedLanguage = await LanguageStorage.getLanguage();
  final initialLocale = savedLanguage != null ? Locale(savedLanguage) : null;

  runApp(
    DevicePreview(
      enabled: true,
      builder:
          (context) =>
              MyApp(initialRoute: initialRoute, initialLocale: initialLocale),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  final Locale? initialLocale;

  const MyApp({super.key, required this.initialRoute, this.initialLocale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends AppState<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    // تطبيق اللغة المحفوظة عند بدء التطبيق
    if (widget.initialLocale != null) {
      _locale = widget.initialLocale;
    }
  }

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    // حفظ اللغة المختارة
    LanguageStorage.saveLanguage(locale.languageCode);
  }

  @override
  void Function(Locale) get setLocale => _setLocale;

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
          BlocProvider(create: (context) => sl<FeedbackCubit>()),
          BlocProvider(create: (context) => ThemeCubit()),
        ],
        child: BlocBuilder<ThemeCubit, bool>(
          builder: (context, isDark) {
            return MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: _locale,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: RoutesManager.router,
              initialRoute: widget.initialRoute,
              theme:
                  isDark
                      ? ThemeData.dark().copyWith(
                        scaffoldBackgroundColor: ColorsManager.primaryColorApp,
                      )
                      : ThemeData.light().copyWith(
                        scaffoldBackgroundColor: ColorsManager.primaryColorApp,
                      ),
            );
          },
        ),
      ),
    );
  }
}
