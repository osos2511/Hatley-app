import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/colors_manager.dart';

class DateTimePickerRow extends StatelessWidget {
  final String dateText;
  final String timeText;
  final VoidCallback onDateTap;
  final VoidCallback onTimeTap;

  const DateTimePickerRow({
    super.key,
    required this.dateText,
    required this.timeText,
    required this.onDateTap,
    required this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onDateTap,
            icon: Icon(Icons.calendar_today, color: ColorsManager.white),
            label: Text(dateText, style: GoogleFonts.inter(color: ColorsManager.white)),
            style: ElevatedButton.styleFrom(backgroundColor: ColorsManager.blue),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onTimeTap,
            icon: Icon(Icons.access_time, color: ColorsManager.white),
            label: Text(timeText, style: GoogleFonts.inter(color: ColorsManager.white)),
            style: ElevatedButton.styleFrom(backgroundColor: ColorsManager.blue),
          ),
        ),
      ],
    );
  }
}
