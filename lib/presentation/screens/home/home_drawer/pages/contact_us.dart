import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatley/core/colors_manager.dart';
import 'package:hatley/l10n/app_localizations.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        padding: REdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.mark_email_read,
              size: 100.sp,
              color: ColorsManager.white,
            ),
            SizedBox(height: 16.h),
            Text(
              AppLocalizations.of(context)!.contact_us_message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                height: 1.5.h,
                color: ColorsManager.white70,
              ),
            ),
            SizedBox(height: 24.h),

            // Input Fields
            _buildTextField(
              label: AppLocalizations.of(context)!.name,
              icon: Icons.person,
            ),
            SizedBox(height: 12.h),
            _buildTextField(
              label: AppLocalizations.of(context)!.email,
              icon: Icons.email,
            ),
            SizedBox(height: 12.h),
            _buildTextField(
              label: AppLocalizations.of(context)!.phone,
              icon: Icons.phone,
            ),
            SizedBox(height: 12.h),
            _buildTextField(
              label: AppLocalizations.of(context)!.enter_your_message,
              icon: Icons.message,
              maxLines: 4,
            ),
            SizedBox(height: 16.h),

            // Send Button
            ElevatedButton(
              onPressed: () {
                // Action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.buttonColorApp,
                minimumSize: Size(screenSize.width * 0.7, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.send,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
