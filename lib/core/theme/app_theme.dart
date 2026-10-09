import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// [AppTheme] : fabrique le thème Material 3 de l'application.
/// On y met uniquement la charte visuelle : police Space Grotesk
/// et couleurs BLOK, plus quelques réglages de composants (AppBar, boutons, cartes).
class AppTheme {
  /// Constructeur privé : la classe ne sert qu'à exposer le thème.
  const AppTheme._();

  /// Thème clair, seul thème de l'application.
  static ThemeData light() {
    final TextTheme baseTextTheme = GoogleFonts.spaceGroteskTextTheme();
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.navy,
    ).copyWith(
      primary: AppColors.navy,
      secondary: AppColors.orange,
      tertiary: AppColors.teal,
      surface: AppColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: baseTextTheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarThemeData(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: baseTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.teal.withValues(alpha: 0.25),
        labelTextStyle: WidgetStatePropertyAll<TextStyle>(
          baseTextTheme.labelMedium ?? const TextStyle(),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        contentTextStyle: baseTextTheme.bodyMedium?.copyWith(
          color: Colors.white,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        space: 1,
        thickness: 1,
      ),
    );
  }
}