import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/colors_manager.dart';
import 'package:hatley/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatley/presentation/cubit/theme_cubit.dart';

class SettingsPage extends StatefulWidget {
  final void Function(Locale)? onLocaleChanged;
  const SettingsPage({super.key, this.onLocaleChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String locale = 'en';

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      backgroundColor: ColorsManager.primaryColorApp,

      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.theme,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.white,
              ),
            ),
            SizedBox(height: 8.h),
            BlocBuilder<ThemeCubit, bool>(
              builder: (context, isDarkTheme) {
                return SwitchListTile(
                  title: Text(
                    isDarkTheme
                        ? AppLocalizations.of(context)!.theme_dark
                        : AppLocalizations.of(context)!.theme_light,
                    style: TextStyle(
                      color: ColorsManager.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  value: isDarkTheme,
                  onChanged: (val) {
                    context.read<ThemeCubit>().setTheme(val);
                  },
                  activeColor: Colors.white, // thumb
                  inactiveThumbColor: Colors.white,
                  activeTrackColor: ColorsManager.buttonColorApp,
                  inactiveTrackColor: ColorsManager.primaryColorApp.withOpacity(
                    0.3,
                  ),
                  contentPadding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity(horizontal: -2, vertical: -2),
                );
              },
            ),
            SizedBox(height: 24.h),
            Text(
              AppLocalizations.of(context)!.language,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.white,
              ),
            ),
            SizedBox(height: 8.h),
            RadioListTile<String>(
              title: Text(
                AppLocalizations.of(context)!.language_en,
                style: TextStyle(color: ColorsManager.white),
              ),
              value: 'en',
              groupValue: locale,
              activeColor: ColorsManager.buttonColorApp,
              onChanged: (val) {
                if (widget.onLocaleChanged != null && locale != 'en') {
                  widget.onLocaleChanged!(const Locale('en'));
                  // تطبيق اللغة فوراً
                  setState(() {});
                }
              },
            ),
            RadioListTile<String>(
              title: Text(
                AppLocalizations.of(context)!.language_ar,
                style: TextStyle(color: ColorsManager.white),
              ),
              value: 'ar',
              groupValue: locale,
              activeColor: ColorsManager.buttonColorApp,
              onChanged: (val) {
                if (widget.onLocaleChanged != null && locale != 'ar') {
                  widget.onLocaleChanged!(const Locale('ar'));
                  // تطبيق اللغة فوراً
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
