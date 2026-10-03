import 'package:flutter/material.dart';
import 'app_colors.dart';

const _bodyFont = 'Inter';
const _headingFont = 'Lora';

ThemeData buildTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? AppColors.dark : AppColors.light;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.light.brand,
        brightness: brightness,
      ).copyWith(
        primary: c.brand,
        onPrimary: c.onBrand,
        secondaryContainer: c.surfaceSoft,
        onSecondaryContainer: c.text,
        surface: c.background,
        onSurface: c.text,
        onSurfaceVariant: c.textMuted,
        surfaceContainerLowest: c.surface,
        surfaceContainerLow: c.surface,
        surfaceContainer: c.surface,
        surfaceContainerHigh: c.surface,
        surfaceContainerHighest: c.surfaceSoft,
        outline: c.textFaint,
        outlineVariant: c.border,
        error: c.danger,
        surfaceTint: Colors.transparent,
      );

  RoundedRectangleBorder rounded(double radius, {bool outlined = false}) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: outlined ? BorderSide(color: c.border) : BorderSide.none,
      );

  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: _bodyFont,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.background,
    extensions: [c],
  );

  final textTheme = base.textTheme
      .apply(bodyColor: c.text, displayColor: c.text)
      .copyWith(
        headlineLarge: TextStyle(
          fontFamily: _headingFont,
          fontSize: 34,
          height: 1.18,
          fontWeight: FontWeight.w700,
          color: c.text,
        ),
        headlineMedium: TextStyle(
          fontFamily: _headingFont,
          fontSize: 26,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: c.text,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          height: 1.3,
          fontWeight: FontWeight.w700,
          color: c.text,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: c.text,
        ),
        bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: c.text),
        bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: c.text),
        bodySmall: TextStyle(fontSize: 12, height: 1.4, color: c.textMuted),
        labelSmall: TextStyle(
          fontSize: 12,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: c.textMuted,
        ),
      );

  return base.copyWith(
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: c.background,
      foregroundColor: c.text,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: textTheme.titleLarge,
    ),
    cardTheme: CardThemeData(
      color: c.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: rounded(14, outlined: true),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      shape: rounded(18),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: c.text,
      contentTextStyle: TextStyle(
        fontFamily: _bodyFont,
        color: c.background,
        fontSize: 14,
      ),
      shape: rounded(12),
    ),
    dividerTheme: DividerThemeData(color: c.border, space: 1),
    chipTheme: ChipThemeData(
      side: BorderSide(color: c.border),
      labelStyle: TextStyle(fontFamily: _bodyFont, fontSize: 13, color: c.text),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: c.brand),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: c.brand,
      foregroundColor: c.onBrand,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c.brand, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c.danger, width: 2),
      ),
      labelStyle: TextStyle(color: c.textMuted),
      hintStyle: TextStyle(color: c.textFaint),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.brand,
        foregroundColor: c.onBrand,
        minimumSize: const Size(0, 56),
        shape: rounded(14),
        textStyle: const TextStyle(
          fontFamily: _bodyFont,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.brand,
        minimumSize: const Size(0, 56),
        side: BorderSide(color: c.border),
        shape: rounded(14),
        textStyle: const TextStyle(
          fontFamily: _bodyFont,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.brand,
        textStyle: const TextStyle(
          fontFamily: _bodyFont,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: c.surface,
      indicatorColor: c.surfaceSoft,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontFamily: _bodyFont,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: states.contains(WidgetState.selected) ? c.text : c.textMuted,
        ),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: c.surface,
      indicatorColor: c.surfaceSoft,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: c.brand,
      unselectedLabelColor: c.textMuted,
      indicatorColor: c.brand,
      labelStyle: const TextStyle(
        fontFamily: _bodyFont,
        fontWeight: FontWeight.w700,
      ),
      dividerColor: c.border,
    ),
  );
}
