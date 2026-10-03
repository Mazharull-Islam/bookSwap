import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/app/app_colors.dart';
import 'package:bookswap_login/app/theme.dart';

double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  final themes = {'light': AppColors.light, 'dark': AppColors.dark};

  for (final entry in themes.entries) {
    final c = entry.value;
    group('${entry.key} palette meets WCAG AA', () {
      final grounds = {
        'background': c.background,
        'surface': c.surface,
        'surfaceSoft': c.surfaceSoft,
      };
      final texts = {
        'text': c.text,
        'textMuted': c.textMuted,
        'textFaint': c.textFaint,
        'brand': c.brand,
        'pending': c.pending,
        'danger': c.danger,
      };
      for (final t in texts.entries) {
        for (final g in grounds.entries) {
          test('${t.key} on ${g.key} >= 4.5', () {
            expect(contrast(t.value, g.value), greaterThanOrEqualTo(4.5));
          });
        }
      }
      test('goldText on goldSurface >= 4.5', () {
        expect(contrast(c.goldText, c.goldSurface), greaterThanOrEqualTo(4.5));
      });
      test('warningText on warningSurface >= 4.5', () {
        expect(
          contrast(c.warningText, c.warningSurface),
          greaterThanOrEqualTo(4.5),
        );
      });
      test('onBrand on brand >= 4.5', () {
        expect(contrast(c.onBrand, c.brand), greaterThanOrEqualTo(4.5));
      });
      test('decorative gold >= 3 on surface and goldSurface', () {
        expect(contrast(c.gold, c.surface), greaterThanOrEqualTo(3));
        expect(contrast(c.gold, c.goldSurface), greaterThanOrEqualTo(3));
      });
    });
  }

  group('status chip fills carry white text', () {
    const fills = {
      'pending': StatusFills.pending,
      'accepted': StatusFills.accepted,
      'lent': StatusFills.lent,
      'returned': StatusFills.returned,
      'danger': StatusFills.danger,
    };
    for (final f in fills.entries) {
      test('${f.key} >= 4.5', () {
        expect(contrast(Colors.white, f.value), greaterThanOrEqualTo(4.5));
      });
    }
  });

  test('both themes build and expose the colour extension', () {
    for (final b in Brightness.values) {
      final theme = buildTheme(b);
      expect(theme.brightness, b);
      expect(theme.extension<AppColors>(), isNotNull);
    }
  });
}
