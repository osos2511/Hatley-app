import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/colors_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkTheme = false;
  String locale = 'en';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsManager.primaryColorApp,
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.white,
              ),
            ),
            SizedBox(height: 8.h),
            SwitchListTile(
              title: Text(
                isDarkTheme ? 'Dark' : 'Light',
                style: TextStyle(
                  color: ColorsManager.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              value: isDarkTheme,
              onChanged: (val) {
                setState(() {
                  isDarkTheme = val;
                });
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
            ),
            SizedBox(height: 24.h),
            Text(
              'Language',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.white,
              ),
            ),
            SizedBox(height: 8.h),
            RadioListTile<String>(
              title: Text(
                'English',
                style: TextStyle(color: ColorsManager.white),
              ),
              value: 'en',
              groupValue: locale,
              activeColor: ColorsManager.buttonColorApp,
              onChanged: (val) {
                setState(() {
                  locale = val!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text(
                'العربية',
                style: TextStyle(color: ColorsManager.white),
              ),
              value: 'ar',
              groupValue: locale,
              activeColor: ColorsManager.buttonColorApp,
              onChanged: (val) {
                setState(() {
                  locale = val!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
