import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/app.dart';
import 'package:kids_routine/data/db/database.dart';
import 'package:kids_routine/router.dart';
import 'package:kids_routine/state/providers.dart';
import 'package:kids_routine/ui/mascot/mascot.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  /// [size] in logical pixels.
  Future<void> pumpApp(
    WidgetTester tester, {
    required Size size,
    double textScale = 1,
    bool disableAnimations = false,
  }) async {
    tester.view.physicalSize = size * 3;
    tester.view.devicePixelRatio = 3;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    if (disableAnimations) {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
    }
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    db = makeTestDb();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          mediaStoreProvider.overrideWithValue(makeTestMedia()),
          audioProvider.overrideWithValue(FakeAudio()),
          recorderProvider.overrideWithValue(FakeRecorder()),
          remindersProvider.overrideWithValue(FakeReminders()),
          clockProvider.overrideWithValue(() => DateTime(2026, 10, 5, 7)),
        ],
        child: const KidsRoutineApp(),
      ),
    );
    container = ProviderScope.containerOf(
      tester.element(find.byType(KidsRoutineApp)),
    );
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox());
      await db.close();
    });
    await settle(tester);
  }

  Future<void> go(WidgetTester tester, String location) async {
    container.read(routerProvider).go(location);
    await settle(tester);
  }

  // A small phone (360 x 640 dp) with the largest system text Android offers
  // (200%). Any overflow fails the test.
  const small = Size(360, 640);

  for (final lang in AppLanguage.values) {
    testWidgets('child screens fit at 200% text on a small phone ($lang)', (
      tester,
    ) async {
      await pumpApp(tester, size: small, textScale: 2);
      await tester.runAsync(
        () => container.read(repositoryProvider).setLanguage(lang),
      );
      await settle(tester);
      expect(tester.takeException(), isNull);
      await go(tester, '/routine/morning');
      expect(tester.takeException(), isNull);
      await go(tester, '/celebrate/morning');
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('parent screens fit at 200% text on a small phone', (
    tester,
  ) async {
    await pumpApp(tester, size: small, textScale: 2);
    container.read(parentSessionProvider.notifier).unlock();
    for (final location in [
      '/gate',
      '/parent',
      '/parent/routine/morning',
      '/parent/tasks',
      '/parent/tasks/1',
      '/parent/rewards',
      '/parent/rewards/new',
      '/parent/summary',
      '/parent/settings',
    ]) {
      await go(tester, location);
      expect(tester.takeException(), isNull, reason: location);
    }
  });

  testWidgets('tablet landscape: task beside a progress rail', (tester) async {
    await pumpApp(tester, size: const Size(1280, 800));
    await go(tester, '/routine/morning');
    expect(find.bySemanticsLabel('המשימות של השגרה'), findsOneWidget);
    // Current task in the big pane and in the rail; the rest only in the rail.
    expect(find.text('קימה מהמיטה'), findsNWidgets(2));
    expect(find.text('מעיל'), findsOneWidget);
    expect(find.text('סיימתי!'), findsOneWidget);
  });

  testWidgets('phone portrait: no rail', (tester) async {
    await pumpApp(tester, size: const Size(412, 915));
    await go(tester, '/routine/morning');
    expect(find.bySemanticsLabel('המשימות של השגרה'), findsNothing);
    expect(find.text('מעיל'), findsNothing);
  });

  testWidgets('the pie timer tells screen readers the time left', (
    tester,
  ) async {
    await pumpApp(tester, size: const Size(412, 915));
    await go(tester, '/routine/morning');
    // wake_up: 2 minutes, just started.
    expect(find.bySemanticsLabel('נשארו 2 דקות'), findsOneWidget);
  });

  testWidgets('with "remove animations" on, the mascot holds still', (
    tester,
  ) async {
    await pumpApp(tester, size: const Size(412, 915), disableAnimations: true);
    final painter =
        tester
                .widget<CustomPaint>(
                  find.descendant(
                    of: find.byType(Mascot),
                    matching: find.byType(CustomPaint),
                  ),
                )
                .painter!
            as MascotPainter;
    await tester.pump(const Duration(seconds: 2));
    final later =
        tester
                .widget<CustomPaint>(
                  find.descendant(
                    of: find.byType(Mascot),
                    matching: find.byType(CustomPaint),
                  ),
                )
                .painter!
            as MascotPainter;
    expect(painter.phase, 0);
    expect(later.phase, 0);
  });
}

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.runAsync(
      () => Future.delayed(const Duration(milliseconds: 5)),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }
}
