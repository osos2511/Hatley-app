import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/core/colors_manager.dart';
import 'package:hatley/core/routes_manager.dart';
import 'package:hatley/presentation/cubit/navigation_cubit.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_button.dart';
import 'package:hatley/presentation/screens/auth/widgets/custom_toast.dart';
import 'package:hatley/presentation/screens/home/home_drawer/pages/about_us.dart';
import 'package:hatley/presentation/screens/home/home_drawer/pages/contact_us.dart';
import 'package:hatley/presentation/screens/home/home_drawer/pages/deliveries.dart';
import 'package:hatley/presentation/screens/home/home_drawer/pages/our_team.dart';
import 'package:hatley/presentation/screens/home/home_drawer/pages/profile.dart';
import 'package:hatley/presentation/screens/home/home_drawer/widgets/custom_drawer.dart';
import 'package:hatley/presentation/screens/home/home_drawer/pages/my_orders.dart';
import 'package:hatley/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:hatley/presentation/cubit/auth_cubit/auth_state.dart';
import 'package:hatley/presentation/cubit/tracking_cubit/tracking_state.dart';
import 'package:hatley/presentation/screens/home/home_drawer/pages/all_tracking_orders.dart';
import '../../../../cubit/tracking_cubit/tracking_cubit.dart';
import '../../../../../core/missing_fields_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _hasCheckedToken = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasCheckedToken) {
      _hasCheckedToken = true;

      final int? initialPage =
          ModalRoute.of(context)?.settings.arguments as int?;
      if (initialPage != null) {
        context.read<NavigationCubit>().changePage(initialPage);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AuthCubit>().checkTokenAndNavigate();
      });
    }
  }

  void _showSessionExpiredDialog() {
    showMissingFieldsDialog(
      context,
      'Your session has expired. Please log in again.',
      onOkPressed: () {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(RoutesManager.signInRoute, (route) => false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) => current is TokenInvalid,
          listener: (context, state) {
            if (state is TokenInvalid) {
              _showSessionExpiredDialog();
            }
          },
        ),
        BlocListener<TrackingCubit, TrackingState>(
          listenWhen: (previous, current) => current is TrackingError,
          listener: (context, state) {
            if (state is TrackingError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                CustomToast.show(message: "An error occurred while tracking. Please try again.");
              });
            }
          },
        ),

      ],
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.h),
          child: BlocBuilder<NavigationCubit, int>(
            builder: (context, state) {
              String appBarTitle;
              switch (state) {
                case 1:
                  appBarTitle = 'Track Orders'; // الكلمة الإنجليزية
                  break;
                case 2:
                  appBarTitle = 'Contact Us'; // الكلمة الإنجليزية
                  break;
                case 3:
                  appBarTitle = 'About Us'; // الكلمة الإنجليزية
                  break;
                case 4:
                  appBarTitle = 'Our Team'; // الكلمة الإنجليزية
                  break;
                case 5:
                  appBarTitle = 'My Orders'; // الكلمة الإنجليزية
                  break;
                case 6:
                  appBarTitle = 'Deliveries'; // الكلمة الإنجليزية
                  break;
                case 7:
                  appBarTitle = 'Profile'; // الكلمة الإنجليزية
                  break;
                default:
                  appBarTitle = 'Home'; // الكلمة الإنجليزية
              }

              return AppBar(
                title: Text(
                  appBarTitle,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: ColorsManager.primaryColorApp,
              );
            },
          ),
        ),
        drawer: const CustomDrawer(),
        body: BlocBuilder<NavigationCubit, int>(
          builder: (context, state) {
            switch (state) {
              case 1:
                return const AllTrackingOrdersScreen();
              case 2:
                return const ContactUs();
              case 3:
                return const AboutUs();
              case 4:
                return const OurTeam();
              case 5:
                return const MyOrders();
              case 6:
                return Deliveries();
              case 7:
                return const Profile();
              default:
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hatley – The easiest way to get your orders delivered',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 22.sp,
                          color: ColorsManager.white70,

                        ),
                      ),
                      SizedBox(height: 16.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.asset(
                          height: 300,
                          'assets/delivery.jpg',
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Center(
                        child: CustomButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(RoutesManager.makeOrdersRoute);
                          },
                          text: 'Make Order Now',
                        ),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
