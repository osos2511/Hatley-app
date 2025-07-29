import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatley/core/colors_manager.dart';
import 'package:hatley/l10n/app_localizations.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.about_us_message,
              style: TextStyle(fontSize: 18.sp, color: ColorsManager.white70),
            ),

            SizedBox(height: 20.h),
            Image.asset('assets/about-us.png'),
          ],
        ),
      ),
    );
  }
}
