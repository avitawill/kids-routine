import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/app.dart';
import 'package:kids_routine/data/db/database.dart';
import 'package:kids_routine/router.dart';
import 'package:kids_routine/state/providers.dart';
import 'package:kids_routine/ui/parent/gate/gear_hold_button.dart';
import 'package:kids_routine/ui/widgets/star_burst.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late FakeAudio audio;
  late ProviderContainer container;
  final now = DateTime(2026, 10, 5, 7, 0);

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    db = makeTestDb();
    audio = FakeAudio();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          mediaStoreProvider.overrideWithValue(makeTestMedia()),
          audioProvider.overrideWithValue(audio),
          recorderProvider.overrideWithValue(FakeRecorder()),
          remindersProvider.overrideWithValue(FakeReminders()),
          clockProvider.overrideWithValue(() => now),
        ],
        child: const KidsRoutineApp(),
      ),
    );
    container = ProviderScope.containerOf(
      tester.element(find.byType(KidsRoutineApp)),
    );
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox());
      await tester.runAsync(db.close);
    });
    await settle(tester);
  }

  testWidgets('tapping the next-task peek does that task first', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('בוקר'));
    await settle(tester);
    expect(find.text('קימה מהמיטה'), findsOneWidget);

    await tester.tap(find.text('שירותים')); // the peek
    await settle(tester);
    expect(audio.events.last, 'announce:toilet');
    // Now toilet is current, and the skipped task is the one peeked at.
    expect(find.text('אחר כך:'), findsOneWidget);
    expect(find.text('קימה מהמיטה'), findsOneWidget);

    await tester.tap(find.text('סיימתי!'));
    await settle(tester);
    await tester.pump(StarBurst.duration);
    await settle(tester);
    // Back to the first task not done: wake up.
    expect(audio.events.last, 'announce:wake_up');
    final s = await tester.runAsync(
      () => container
          .read(repositoryProvider)
          .watchSession(RoutineType.morning, now)
          .first,
    );
    expect(s!.tasks[1].isDone, isTrue);
    expect(s.tasks[0].isDone, isFalse);
  });

  testWidgets('a quick tap on the gear explains to hold it', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byType(GearHoldButton));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('לחיצה ארוכה למצב הורים'), findsOneWidget);
    expect(find.text('רק להורים'), findsNothing);
  });

  testWidgets('the parent can uncheck a task and restart a routine today', (
    tester,
  ) async {
    await pumpApp(tester);
    final repo = container.read(repositoryProvider);
    final s = (await tester.runAsync(
      () => repo.watchSession(RoutineType.morning, now).first,
    ))!;
    for (final t in s.tasks.take(2)) {
      await repo.completeTask(s.routine.id, t.task.id, now);
    }
    container.read(parentSessionProvider.notifier).unlock();
    container.read(routerProvider).go('/parent/summary');
    await settle(tester);

    await tester.tap(find.text('שירותים'));
    await settle(tester);
    expect(
      find.text('לסמן את "שירותים" כלא בוצעה? הכוכב שנאסף נשאר.'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'סימון כלא בוצעה'));
    await settle(tester);
    expect(find.text('שירותים'), findsNothing);
    expect(container.read(starBalanceProvider).value, 2);

    await tester.tap(find.text('איפוס השגרה להיום'));
    await settle(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'איפוס השגרה להיום'));
    await settle(tester);
    expect(find.text('אין פעילות ביום הזה'), findsOneWidget);
    expect(container.read(starBalanceProvider).value, 2);
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
