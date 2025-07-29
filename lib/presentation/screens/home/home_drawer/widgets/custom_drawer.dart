import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatley/core/routes_manager.dart';
import 'package:hatley/presentation/cubit/navigation_cubit.dart';
import '../../../../../core/colors_manager.dart';
import '../../../../../core/missing_fields_dialog.dart';
import '../../../../cubit/auth_cubit/auth_cubit.dart';
import 'custom_listTile.dart';
import 'package:hatley/core/app_state.dart';
import 'package:hatley/l10n/app_localizations.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250.w,
      backgroundColor: ColorsManager.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30.h),
            color: ColorsManager.primaryColorApp,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40.r,
                  backgroundImage: AssetImage('assets/hatley-logo.png'),
                ),
                SizedBox(height: 10.h),
                Text(
                  AppLocalizations.of(context)!.app_title,
                  style: GoogleFonts.lilyScriptOne(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(0);
                    Navigator.pop(context);
                  },
                  icon: Icons.home,
                  text: AppLocalizations.of(context)!.home_title,
                ),
                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(1);
                    Navigator.pop(context);
                  },
                  icon: Icons.local_shipping,
                  text: AppLocalizations.of(context)!.track_orders_title,
                ),
                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(2);
                    Navigator.pop(context);
                  },
                  icon: Icons.phone,
                  text: AppLocalizations.of(context)!.contact_us_title,
                ),
                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(3);
                    Navigator.pop(context);
                  },
                  icon: Icons.info_outline,
                  text: AppLocalizations.of(context)!.about_us_title,
                ),
                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(4);
                    Navigator.pop(context);
                  },
                  icon: Icons.group,
                  text: AppLocalizations.of(context)!.our_team_title,
                ),
                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(5);
                    Navigator.pop(context);
                  },
                  icon: Icons.shopping_cart,
                  text: AppLocalizations.of(context)!.my_orders_title,
                ),

                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(6);
                    Navigator.pop(context);
                  },
                  icon: Icons.delivery_dining,
                  text: AppLocalizations.of(context)!.deliveries_title,
                ),
                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(7);
                    Navigator.pop(context);
                  },
                  icon: Icons.person,
                  text: AppLocalizations.of(context)!.profile_title,
                ),
                CustomListTile(
                  onPress: () {
                    context.read<NavigationCubit>().changePage(8);
                    Navigator.pop(context);
                  },
                  icon: Icons.settings,
                  text: AppLocalizations.of(context)!.settings_title,
                ),

                CustomListTile(
                  onPress: () {
                    showMissingFieldsDialog(
                      context,
                      AppLocalizations.of(context)!.logout_confirmation,
                      onOkPressed: () {
                        context.read<AuthCubit>().logOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          RoutesManager.signInRoute,
                          (route) => false,
                        );
                      },
                    );
                  },
                  icon: Icons.logout,
                  text: AppLocalizations.of(context)!.logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
