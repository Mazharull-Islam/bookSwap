import 'package:flutter/material.dart';

/// Semantic colours, each with a light and a dark value. Read them with
/// `context.colors.textMuted` rather than hard-coding hex values, so dark
/// mode and the contrast test (test/theme_contrast_test.dart) cover them.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceSoft,
    required this.border,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.brand,
    required this.onBrand,
    required this.gold,
    required this.goldText,
    required this.goldSurface,
    required this.pending,
    required this.danger,
    required this.warningText,
    required this.warningSurface,
  });

  final Color background;
  final Color surface;

  /// The pale green panels.
  final Color surfaceSoft;
  final Color border;
  final Color text;
  final Color textMuted;
  final Color textFaint;

  /// Accent for headings, icons and primary buttons.
  final Color brand;
  final Color onBrand;

  /// Decorative gold (borders, icons, stars); [goldText] is for text.
  final Color gold;
  final Color goldText;
  final Color goldSurface;

  /// Orange for pending/extension text; chip fills live in [StatusFills].
  final Color pending;
  final Color danger;
  final Color warningText;
  final Color warningSurface;

  static const light = AppColors(
    background: Color(0xFFFAF8F2),
    surface: Color(0xFFFFFFFF),
    surfaceSoft: Color(0xFFE9EEDF),
    border: Color(0xFFD6DED5),
    text: Color(0xFF24382F),
    textMuted: Color(0xFF4B5B50),
    textFaint: Color(0xFF5F6E63),
    brand: Color(0xFF254E3B),
    onBrand: Color(0xFFFFFFFF),
    gold: Color(0xFFA87414),
    goldText: Color(0xFF765510),
    goldSurface: Color(0xFFFBF1DC),
    pending: Color(0xFF9A5230),
    danger: Color(0xFFB3261E),
    warningText: Color(0xFF7D5610),
    warningSurface: Color(0xFFFFF4E5),
  );

  static const dark = AppColors(
    background: Color(0xFF121A16),
    surface: Color(0xFF1A231E),
    surfaceSoft: Color(0xFF24312A),
    border: Color(0xFF33443A),
    text: Color(0xFFE6EEE8),
    textMuted: Color(0xFFA7B6AC),
    textFaint: Color(0xFF8FA096),
    brand: Color(0xFF8CCBA6),
    onBrand: Color(0xFF10231A),
    gold: Color(0xFFE3B64F),
    goldText: Color(0xFFEBC36A),
    goldSurface: Color(0xFF3A301A),
    pending: Color(0xFFF0A878),
    danger: Color(0xFFFF8F86),
    warningText: Color(0xFFF0C36D),
    warningSurface: Color(0xFF3A2F1A),
  );

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      surfaceSoft: mix(surfaceSoft, other.surfaceSoft),
      border: mix(border, other.border),
      text: mix(text, other.text),
      textMuted: mix(textMuted, other.textMuted),
      textFaint: mix(textFaint, other.textFaint),
      brand: mix(brand, other.brand),
      onBrand: mix(onBrand, other.onBrand),
      gold: mix(gold, other.gold),
      goldText: mix(goldText, other.goldText),
      goldSurface: mix(goldSurface, other.goldSurface),
      pending: mix(pending, other.pending),
      danger: mix(danger, other.danger),
      warningText: mix(warningText, other.warningText),
      warningSurface: mix(warningSurface, other.warningSurface),
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

/// Chip backgrounds that carry white text. Identical in both themes (they're
/// all dark enough for white), so they need no BuildContext.
abstract final class StatusFills {
  static const pending = Color(0xFF9A5230);
  static const accepted = Color(0xFF254E3B);
  static const lent = Color(0xFF3D6FA5);
  static const returned = Color(0xFF66666B);
  static const danger = Color(0xFFB3261E);
}
