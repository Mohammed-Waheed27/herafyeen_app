import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../color/app_theme.dart';

class FontTheme {
  static TextTheme get textTheme {
    return TextTheme(
      // Display styles - for large headlines and important text
      displayLarge: GoogleFonts.cairo(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: lightColorScheme.scrim,
        height: 1.4,
      ),
      displayMedium: GoogleFonts.cairo(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: lightColorScheme.scrim,
        height: 1.4,
      ),
      displaySmall: GoogleFonts.cairo(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: lightColorScheme.scrim,
        height: 1.4,
      ),

      // Headline styles - for section headers
      headlineLarge: GoogleFonts.cairo(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: lightColorScheme.scrim,
        height: 1.4,
      ),
      headlineMedium: GoogleFonts.cairo(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: lightColorScheme.scrim,
        height: 1.4,
      ),
      headlineSmall: GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: lightColorScheme.scrim,
        height: 1.4,
      ),

      // Title styles - for card titles and medium emphasis text
      titleLarge: GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: lightColorScheme.scrim,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.cairo(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: lightColorScheme.scrim,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.cairo(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: lightColorScheme.scrim,
        height: 1.4,
      ),

      // Body styles - for regular text content
      bodyLarge: GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: lightColorScheme.scrim,
        height: 1.4,
      ),
      bodyMedium: GoogleFonts.cairo(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: lightColorScheme.scrim,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.cairo(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: lightColorScheme.scrim,
        height: 1.4,
      ),

      // Label styles - for buttons and form fields
      labelLarge: GoogleFonts.cairo(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: lightColorScheme.scrim,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.cairo(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: lightColorScheme.scrim,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.cairo(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: lightColorScheme.scrim,
        height: 1.4,
      ),
    );
  }
}
