import 'package:flutter/material.dart';
import 'package:hatley/presentation/screens/home/home_drawer/pages/deliveries.dart';
import 'package:hatley/presentation/screens/home/home_drawer/pages/home.dart';
import 'package:hatley/presentation/screens/home/home_drawer/pages/profile.dart';
import 'package:hatley/presentation/screens/home/home_drawer/pages/all_tracking_orders.dart';
import 'package:hatley/presentation/screens/home/make_orders/make_orders.dart';
import 'package:hatley/presentation/screens/splash/splash.dart';
import '../presentation/screens/auth/forgot_password.dart';
import '../presentation/screens/auth/otp.dart';
import '../presentation/screens/auth/reset_password.dart';
import '../presentation/screens/auth/sign_in.dart';
import '../presentation/screens/auth/sign_up.dart';
import '../presentation/screens/home/home_drawer/pages/my_orders.dart';
import '../presentation/screens/home/home_drawer/widgets/track_order_widget.dart'; // **** أضف هذا الاستيراد ****


class RoutesManager {
  static const String splashRoute = '/';
  static const String signInRoute = '/signIn';
  static const String signUpRoute = '/SignUp';
  static const String otpRoute = '/otp';
  static const String forgotPassRoute = '/forgotPass';
  static const String resetPassRoute = '/resetPass';
  static const String homeRoute = '/home';
  static const String makeOrdersRoute = '/makeOrders';
  static const String myOrdersRoute = '/myOrder';
  static const String deliveriesRoute = '/deliveries';
  static const String profileRoute = '/Profile';
  static const String trakingRoute = '/traking'; // **** أضف هذا ****

  static Route<dynamic>? router(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        {
          return MaterialPageRoute(builder: (context) => const Splash());
        }
      case signUpRoute:
        {
          return MaterialPageRoute(builder: (context) => SignUpScreen());
        }

      case signInRoute:
        {
          return MaterialPageRoute(builder: (context) => SignInScreen());
        }
      case forgotPassRoute:
        {
          return MaterialPageRoute(builder: (context) => EnterEmailOrPass());
        }
      case otpRoute:
        {
          return MaterialPageRoute(builder: (context) => Otp());
        }
      case resetPassRoute:
        {
          return MaterialPageRoute(builder: (context) => ResetPass());
        }
      case homeRoute:
        {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => Home(),
          );
        }

      case makeOrdersRoute:
        {
          return MaterialPageRoute(builder: (context) => MakeOrders());
        }

      case myOrdersRoute:
        return MaterialPageRoute(
          builder: (context) => MyOrders(),
        );

      case deliveriesRoute:
        {
          return MaterialPageRoute(builder: (context) => Deliveries());
        }
      case profileRoute:
        {
          return MaterialPageRoute(builder: (context) => Profile());
        }
      case trakingRoute:
        {
          return MaterialPageRoute(
            builder: (context) => AllTrackingOrdersScreen(),
          );
        }
    }
    return null;
  }
}