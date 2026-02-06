import 'package:flutter/material.dart';
import 'package:barber_booking_app/services/colors.dart';

// AppTheme waa meesha aan ku nidaamino muuqaalka guud ee abka (Global Styling).
// Concept: 'ThemeData' waxay noo ogolaanaysaa inaan hal mar qeexno midabada, farta (fonts), iyo qaabka badhamada.
// Tani waxay naga badbaadinaysaa inaan widget kasta gacanta ku style-gareyno.
class AppTheme {
  // Waxaan isticmaalaynaa '.dark()' oo ah theme-ka madow ee Flutter, ka dibna waxaan ku dareynaa '.copyWith' si aan u waafajino midabada aan rabno.
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    cardColor: AppColors.card,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      surface: AppColors.card,
      error: AppColors.error,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primaryLight,
      selectionHandleColor: AppColors.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.card,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      prefixIconColor: AppColors.textSecondary,
    ),
  );
}

class AppTextStyles {
  static TextStyle heading(double size) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: AppColors.primary,
    );
  }

  static TextStyle body(double size, {Color color = AppColors.textPrimary}) {
    return TextStyle(fontSize: size, color: color);
  }
}
