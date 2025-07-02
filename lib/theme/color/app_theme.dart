import 'package:flutter/material.dart';

final lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0XFFFF6B01), // Main brand color (vibrant orange)
  onPrimary: Colors.white, // Text/icons on primary & mian background
  primaryContainer: Color(0XFFFF9549), //scound orange

  secondary: Color(0XFF0066CC), // Complementary blue
  onSecondary: Color(0XFFF0F2F9), // scoundary background
  secondaryContainer: Color(0XFFFFD3B3), // third orange

  tertiary: Color(0XFF00AA55), // Analogous green for success/accent
  onTertiary: Colors.white, // Text/icons on tertiary

  error: Color(0xFFD32F2F), // Standard error red
  onError: Colors.white, // Primary text

  surface: Color(0XFF8F959A), // scoundary gray
  onSurface: const Color.fromARGB(255, 231, 230, 230), // Text/icons on surface

  outline: Color(0XFFD0D0D0), // Borders/divider
  outlineVariant: Color(0XFFE8E8E8), // Subtle borders

  surfaceContainerHighest: Color(0XFFF3F3F3), // Alternative surface color
  scrim: Color(0XCC000000), // Scrim overlay

  // Neutrals with different shades
  inverseSurface: Color(0XFF121212),
  inversePrimary: Color(0XFFFFD9C2),
  shadow: Color(0X40000000),
);
