import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/app/app_colors.dart';
import 'package:bookswap_login/app/theme.dart';
import 'package:bookswap_login/shared/widgets/empty_state.dart';
import 'package:bookswap_login/shared/widgets/feedback.dart';
import 'package:bookswap_login/shared/widgets/inline_spinner.dart';
import 'package:bookswap_login/shared/widgets/primary_button.dart';
import 'package:bookswap_login/shared/widgets/secondary_button.dart';
import 'package:bookswap_login/shared/widgets/status_chip.dart';

Widget host(Widget child) => MaterialApp(
  theme: buildTheme(Brightness.light),
  home: Scaffold(body: child),
);

void main() {
  group('EmptyState', () {
    testWidgets('shows the icon and the message, centred', (tester) async {
      await tester.pumpWidget(
        host(
          const EmptyState(icon: Icons.forum_outlined, message: 'Nothing here'),
        ),
      );
      expect(find.byIcon(Icons.forum_outlined), findsOneWidget);
      expect(find.text('Nothing here'), findsOneWidget);
      final text = tester.widget<Text>(find.text('Nothing here'));
      expect(text.textAlign, TextAlign.center);
      final icon = tester.widget<Icon>(find.byIcon(Icons.forum_outlined));
      expect(icon.size, 56);
    });

    testWidgets('a title adds a heading above the message', (tester) async {
      await tester.pumpWidget(
        host(
          const EmptyState(
            icon: Icons.menu_book_outlined,
            title: 'Your shelf is empty',
            message: 'Add a book to get started.',
          ),
        ),
      );
      expect(find.text('Your shelf is empty'), findsOneWidget);
      expect(find.text('Add a book to get started.'), findsOneWidget);
      final titleY = tester.getTopLeft(find.text('Your shelf is empty')).dy;
      final messageY = tester
          .getTopLeft(find.text('Add a book to get started.'))
          .dy;
      expect(titleY, lessThan(messageY));
    });

    testWidgets('the message is the muted text colour', (tester) async {
      await tester.pumpWidget(
        host(const EmptyState(icon: Icons.search_off, message: 'No matches')),
      );
      final context = tester.element(find.byType(EmptyState));
      expect(
        tester.widget<Text>(find.text('No matches')).style?.color,
        context.colors.textMuted,
      );
    });

    testWidgets('long text wraps instead of overflowing a narrow screen', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(200, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        host(
          const EmptyState(
            icon: Icons.search_off,
            message:
                'No books on your shelf match your search or filters, so try '
                'removing a filter or adding a new book.',
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('StatusChip', () {
    testWidgets('is white text on the given fill', (tester) async {
      await tester.pumpWidget(
        host(const StatusChip(label: 'Overdue', color: Color(0xFFB3261E))),
      );
      expect(find.text('Overdue'), findsOneWidget);
      final chip = tester.widget<Chip>(find.byType(Chip));
      expect(chip.backgroundColor, const Color(0xFFB3261E));
      final label = tester.widget<Text>(find.text('Overdue'));
      expect(label.style?.color, Colors.white);
      expect(label.style?.fontWeight, FontWeight.w600);
      expect(label.style?.fontSize, 12);
    });

    testWidgets('the brand variant uses the accent colours', (tester) async {
      await tester.pumpWidget(host(const StatusChip.brand(label: '3 members')));
      final context = tester.element(find.byType(StatusChip));
      final chip = tester.widget<Chip>(find.byType(Chip));
      expect(chip.backgroundColor, context.colors.brand);
      expect(
        tester.widget<Text>(find.text('3 members')).style?.color,
        context.colors.onBrand,
      );
    });

    testWidgets('can drop its tap-target padding', (tester) async {
      await tester.pumpWidget(
        host(
          const Column(
            children: [
              StatusChip(label: 'A', color: Colors.green),
              StatusChip(
                label: 'B',
                color: Colors.green,
                shrinkTapTarget: true,
              ),
            ],
          ),
        ),
      );
      final chips = tester.widgetList<Chip>(find.byType(Chip)).toList();
      expect(chips[0].materialTapTargetSize, isNull);
      expect(chips[1].materialTapTargetSize, MaterialTapTargetSize.shrinkWrap);
      expect(
        tester.getSize(find.byType(Chip).at(1)).height,
        lessThanOrEqualTo(tester.getSize(find.byType(Chip).at(0)).height),
      );
    });
  });

  group('InlineSpinner', () {
    testWidgets('is a small spinner', (tester) async {
      await tester.pumpWidget(host(const Center(child: InlineSpinner())));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(tester.getSize(find.byType(InlineSpinner)), const Size(16, 16));
    });
  });

  group('showMessage', () {
    testWidgets('shows the text in a snackbar', (tester) async {
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showMessage(context, 'Saved.'),
              child: const Text('go'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Saved.'), findsOneWidget);
    });
  });

  group('showConfirmDialog', () {
    Future<bool?> open(
      WidgetTester tester, {
      bool destructive = false,
      Future<void> Function()? act,
    }) async {
      bool? result;
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await showConfirmDialog(
                  context,
                  title: 'Delete it?',
                  message: 'This cannot be undone.',
                  confirmLabel: 'Delete',
                  destructive: destructive,
                );
              },
              child: const Text('go'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      expect(find.text('Delete it?'), findsOneWidget);
      expect(find.text('This cannot be undone.'), findsOneWidget);
      await act?.call();
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets('confirming returns true', (tester) async {
      final result = await open(
        tester,
        act: () => tester.tap(find.widgetWithText(FilledButton, 'Delete')),
      );
      expect(result, isTrue);
    });

    testWidgets('cancelling returns false', (tester) async {
      final result = await open(
        tester,
        act: () => tester.tap(find.text('Cancel')),
      );
      expect(result, isFalse);
    });

    testWidgets('tapping outside the dialog counts as cancelling', (
      tester,
    ) async {
      final result = await open(
        tester,
        act: () => tester.tapAt(const Offset(5, 5)),
      );
      expect(result, isFalse);
    });

    testWidgets('destructive turns the confirm button into the error colour', (
      tester,
    ) async {
      await open(tester, destructive: true);
      final scheme = Theme.of(
        tester.element(find.byType(AlertDialog)),
      ).colorScheme;
      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Delete'),
      );
      expect(button.style?.backgroundColor?.resolve({}), scheme.error);
    });

    testWidgets('a normal confirm uses the default button style', (
      tester,
    ) async {
      await open(tester);
      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Delete'),
      );
      expect(button.style, isNull);
    });
  });

  group('PrimaryButton', () {
    testWidgets('shows its label and calls onPressed', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        host(PrimaryButton(label: 'Save', onPressed: () => taps++)),
      );
      await tester.tap(find.text('Save'));
      expect(taps, 1);
    });

    testWidgets('with no handler it is disabled', (tester) async {
      await tester.pumpWidget(
        host(const PrimaryButton(label: 'Save', onPressed: null)),
      );
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
    });

    testWidgets('loading swaps the label for a spinner and ignores taps', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          PrimaryButton(label: 'Save', onPressed: () => taps++, loading: true),
        ),
      );
      expect(find.text('Save'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(FilledButton), warnIfMissed: false);
      expect(taps, 0);
    });

    testWidgets('destructive uses the error colour, normal does not', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          Column(
            children: [
              PrimaryButton(label: 'Normal', onPressed: () {}),
              PrimaryButton(
                label: 'Danger',
                onPressed: () {},
                destructive: true,
              ),
            ],
          ),
        ),
      );
      final error = Theme.of(
        tester.element(find.text('Normal')),
      ).colorScheme.error;
      final normal = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Normal'),
      );
      final danger = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Danger'),
      );
      expect(normal.style, isNull);
      expect(danger.style?.backgroundColor?.resolve({}), error);
    });

    testWidgets('the key lands on the button', (tester) async {
      await tester.pumpWidget(
        host(
          PrimaryButton(
            buttonKey: const Key('go'),
            label: 'Go',
            onPressed: () {},
          ),
        ),
      );
      expect(tester.widget(find.byKey(const Key('go'))), isA<FilledButton>());
    });
  });

  group('SecondaryButton', () {
    testWidgets('is an outlined button with its label', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        host(SecondaryButton(label: 'Cancel it', onPressed: () => taps++)),
      );
      expect(find.byType(OutlinedButton), findsOneWidget);
      await tester.tap(find.text('Cancel it'));
      expect(taps, 1);
    });

    testWidgets('an icon sits beside the label', (tester) async {
      await tester.pumpWidget(
        host(
          SecondaryButton(
            label: 'Scan',
            icon: Icons.qr_code_scanner,
            onPressed: () {},
          ),
        ),
      );
      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
      expect(find.text('Scan'), findsOneWidget);
    });

    testWidgets('with no handler it is disabled', (tester) async {
      await tester.pumpWidget(
        host(const SecondaryButton(label: 'Voted', onPressed: null)),
      );
      expect(
        tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
        isNull,
      );
    });

    testWidgets('loading shows a spinner and ignores taps', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          SecondaryButton(
            label: 'Update',
            onPressed: () => taps++,
            loading: true,
          ),
        ),
      );
      expect(find.text('Update'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(OutlinedButton), warnIfMissed: false);
      expect(taps, 0);
    });

    testWidgets('the key lands on the button', (tester) async {
      await tester.pumpWidget(
        host(
          SecondaryButton(
            buttonKey: const Key('rate'),
            label: 'Rate',
            onPressed: () {},
          ),
        ),
      );
      expect(
        tester.widget(find.byKey(const Key('rate'))),
        isA<OutlinedButton>(),
      );
    });
  });

  group('conventions', () {
    List<String> filesContaining(
      Pattern pattern, {
      Set<String> except = const {},
    }) {
      final hits = <String>[];
      for (final entity in Directory('lib').listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final path = entity.path.replaceAll('\\', '/');
        if (except.contains(path) ||
            path.endsWith('.g.dart') ||
            path.endsWith('.freezed.dart')) {
          continue;
        }
        if (entity.readAsStringSync().contains(pattern)) hits.add(path);
      }
      return hits;
    }

    const feedbackFile = 'lib/shared/widgets/feedback.dart';

    test('messages go through showMessage, not raw snackbars', () {
      expect(filesContaining('showSnackBar(', except: {feedbackFile}), isEmpty);
    });

    test('yes/no questions go through showConfirmDialog', () {
      expect(
        filesContaining('showDialog<bool>', except: {feedbackFile}),
        isEmpty,
      );
    });

    test(
      'buttons are PrimaryButton or SecondaryButton, not raw Material ones',
      () {
        expect(
          filesContaining(
            RegExp(r'\b(OutlinedButton|FilledButton|ElevatedButton)\b'),
            except: {
              'lib/shared/widgets/primary_button.dart',
              'lib/shared/widgets/secondary_button.dart',
              'lib/app/theme.dart',
            },
          ),
          isEmpty,
        );
      },
    );

    test('small spinners use InlineSpinner', () {
      expect(
        filesContaining(
          'CircularProgressIndicator(strokeWidth: 2)',
          except: {'lib/shared/widgets/inline_spinner.dart'},
        ),
        isEmpty,
      );
    });

    test('there is one empty-state widget, not private copies', () {
      expect(
        filesContaining(RegExp(r'class _Hint\b|class _EmptyShelf\b')),
        isEmpty,
      );
    });
  });
}
