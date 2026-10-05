import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/app.dart';
import 'package:kids_routine/data/db/database.dart';
import 'package:kids_routine/router.dart';
import 'package:kids_routine/services/media_store.dart';
import 'package:kids_routine/state/providers.dart';
import 'package:kids_routine/ui/parent/gate/gear_hold_button.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late MediaStore media;
  late FakeRecorder recorder;
  late FakeAudio audio;
  late ProviderContainer container;
  final now = DateTime(2026, 10, 5, 8, 0);

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    db = makeTestDb();
    // Unmount first so no live query is left waiting when the DB closes
    // (otherwise a failing test hangs the runner instead of reporting).
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox());
      await db.close();
    });
    media = makeTestMedia();
    recorder = FakeRecorder();
    audio = FakeAudio();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          mediaStoreProvider.overrideWithValue(media),
          audioProvider.overrideWithValue(audio),
          remindersProvider.overrideWithValue(FakeReminders()),
          recorderProvider.overrideWithValue(recorder),
          clockProvider.overrideWithValue(() => now),
        ],
        child: const KidsRoutineApp(),
      ),
    );
    container = ProviderScope.containerOf(
      tester.element(find.byType(KidsRoutineApp)),
    );
    await settle(tester);
  }

  Future<void> openParent(WidgetTester tester, String location) async {
    container.read(parentSessionProvider.notifier).unlock();
    container.read(routerProvider).go(location);
    await settle(tester);
  }

  Future<void> earnStars(int n) async {
    final repo = container.read(repositoryProvider);
    final s = await repo.watchSession(RoutineType.morning, now).first;
    for (final t in s.tasks.take(n)) {
      await repo.completeTask(s.routine.id, t.task.id, now);
    }
  }

  Future<List<String?>> morningKeys() async {
    final repo = container.read(repositoryProvider);
    final s = await repo.watchSession(RoutineType.morning, now).first;
    return [for (final t in s.tasks) t.task.builtInKey ?? t.task.nameHe];
  }

  Finder padKey(String label) => find.widgetWithText(FilledButton, label);

  group('parent gate', () {
    testWidgets('a short press does nothing; holding 2 s opens the question', (
      tester,
    ) async {
      await pumpApp(tester);
      final gear = tester.getCenter(find.byType(GearHoldButton));

      final quick = await tester.startGesture(gear);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1800));
      await quick.up();
      await settle(tester);
      expect(find.text('רק להורים'), findsNothing);

      final hold = await tester.startGesture(gear);
      await tester.pump(); // the hold animation starts on this frame
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1, milliseconds: 50));
      await hold.up();
      await settle(tester);
      expect(find.text('רק להורים'), findsOneWidget);
    });

    testWidgets(
      'wrong answer gives a new question; right answer opens parent mode',
      (tester) async {
        await pumpApp(tester);
        container.read(routerProvider).push('/gate');
        await settle(tester);

        (int, int) question() {
          final text = tester
              .widgetList<Text>(find.byType(Text))
              .map((t) => t.data ?? '')
              .firstWhere((s) => s.contains('×'));
          final m = RegExp(r'(\d+) × (\d+)').firstMatch(text)!;
          return (int.parse(m[1]!), int.parse(m[2]!));
        }

        Future<void> enter(int value) async {
          for (final d in '$value'.split('')) {
            await tester.tap(padKey(d));
            await tester.pump();
          }
          await tester.tap(find.bySemanticsLabel('אישור'));
          await settle(tester);
        }

        final (a, b) = question();
        await enter(a * b + 1);
        expect(find.text('לא בדיוק. הנה שאלה אחרת.'), findsOneWidget);
        expect(question(), isNot((a, b)));
        expect(container.read(parentSessionProvider), isFalse);

        final (c, d) = question();
        await enter(c * d);
        expect(container.read(parentSessionProvider), isTrue);
        expect(find.text('מצב הורים'), findsOneWidget);
      },
    );

    testWidgets(
      'parent mode locks when the app is hidden, and /parent then redirects home',
      (tester) async {
        await pumpApp(tester);
        await openParent(tester, '/parent');
        expect(find.text('מצב הורים'), findsOneWidget);

        container.read(parentSessionProvider.notifier).onAppHidden();
        await settle(tester);
        expect(find.text('בוקר טוב!'), findsOneWidget);

        container.read(routerProvider).go('/parent/rewards');
        await settle(tester);
        expect(find.text('פרסים'), findsNothing);
        expect(find.text('בוקר טוב!'), findsOneWidget);
      },
    );

    testWidgets('the camera/gallery does not lock parent mode', (tester) async {
      await pumpApp(tester);
      await openParent(tester, '/parent');
      final session = container.read(parentSessionProvider.notifier);
      await session.whileOutside(() async => session.onAppHidden());
      expect(container.read(parentSessionProvider), isTrue);
    });

    testWidgets('Exit locks and goes home', (tester) async {
      await pumpApp(tester);
      await openParent(tester, '/parent');
      await tester.tap(find.byTooltip('יציאה ממצב הורים'));
      await settle(tester);
      expect(container.read(parentSessionProvider), isFalse);
      expect(find.text('בוקר טוב!'), findsOneWidget);
    });
  });

  group('routine editor', () {
    testWidgets('drag reorders, remove removes, add appends from the library', (
      tester,
    ) async {
      await pumpApp(tester);
      await openParent(tester, '/parent/routine/morning');
      expect(find.text('קימה מהמיטה'), findsOneWidget);

      // Drag the first task down past the second.
      final drag = await tester.startGesture(
        tester.getCenter(find.byIcon(Icons.drag_handle_rounded).first),
      );
      for (var i = 0; i < 6; i++) {
        await drag.moveBy(const Offset(0, 20));
        await tester.pump(const Duration(milliseconds: 50));
      }
      await drag.up();
      await settle(tester);
      final order = await morningKeys();
      expect(order.first, 'toilet');
      expect(order.indexOf('wake_up'), greaterThan(0));

      // Remove the (new) first task.
      await tester.tap(find.byTooltip('הסרה מהשגרה').first);
      await settle(tester);
      expect(await morningKeys(), isNot(contains('toilet')));
      expect(await morningKeys(), hasLength(9));

      // Add a noon task from the library.
      await tester.tap(find.text('הוספת משימה'));
      await settle(tester);
      await tester.scrollUntilVisible(
        find.text('רחיצת ידיים'),
        100,
        scrollable: find
            .descendant(
              of: find.byType(DraggableScrollableSheet),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.tap(find.text('רחיצת ידיים'));
      await settle(tester);
      expect((await morningKeys()).last, 'wash_hands');
    });

    testWidgets('a new task with emoji and a recording is added to the routine', (
      tester,
    ) async {
      await pumpApp(tester);
      await openParent(tester, '/parent/routine/morning');

      await tester.tap(find.text('הוספת משימה'));
      await settle(tester);
      await tester.tap(find.text('משימה חדשה'));
      await settle(tester);

      // Saving without a Hebrew name is refused.
      await tester.tap(find.text('שמירה'));
      await settle(tester);
      expect(find.text('צריך שם בעברית'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'שם בעברית'),
        'האכלת הכלב',
      );
      await tester.tap(find.text('אימוג׳י'));
      await settle(tester);
      await tester.tap(find.text('🐶'));
      await settle(tester);

      await tester.tap(find.byIcon(Icons.mic_rounded));
      await settle(tester);
      expect(recorder.recordingTo, isNotNull);
      await tester.tap(find.byIcon(Icons.stop_rounded));
      await settle(tester);
      await tester.tap(find.text('השמעה'));
      await settle(tester);
      expect(audio.events.last, startsWith('play:media/audio/'));

      await tester.tap(find.byIcon(Icons.add_rounded).last); // minutes 3 -> 4
      await tester.tap(find.text('שמירה'));
      await settle(tester);
      debugPrint(
        'DBG tasks: ${(await db.select(db.tasks).get()).map((t) => t.nameHe).toList().reversed.take(2)}',
      );
      debugPrint(
        'DBG errors: ${find.text('צריך שם בעברית').evaluate().length} editor: ${find.text('משימה חדשה').evaluate().length}',
      );

      expect((await morningKeys()).last, 'האכלת הכלב');
      final task = (await (db.select(
        db.tasks,
      )..where((t) => t.nameHe.equals('האכלת הכלב'))).getSingle());
      expect(task.emoji, '🐶');
      expect(task.targetMinutes, 4);
      expect(task.pack, TaskPack.custom);
      expect(media.existing(task.audioPath), isNotNull);
      expect(
        find.text('🌅 בוקר'),
        findsOneWidget,
      ); // back in the routine editor
    });

    testWidgets('leaving a new task without saving deletes its recording', (
      tester,
    ) async {
      await pumpApp(tester);
      await openParent(tester, '/parent/tasks');
      await tester.tap(find.text('משימה חדשה'));
      await settle(tester);
      await tester.tap(find.byIcon(Icons.mic_rounded));
      await settle(tester);
      final path = recorder.recordingTo!;
      await tester.tap(find.byIcon(Icons.stop_rounded));
      await settle(tester);

      final back = find.byType(BackButton);
      await tester.tap(back);
      await settle(tester);
      await tester.tap(find.text('יציאה בלי שמירה'));
      await settle(tester);
      expect(find.text('ספריית משימות'), findsOneWidget);
      // Let the real file deletion finish.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      expect(
        media.root.listSync(recursive: true).map((f) => f.path),
        isNot(contains(path)),
      );
    });
  });

  group('rewards', () {
    testWidgets(
      'create, see progress on the celebration, redeem together, offer again',
      (tester) async {
        await pumpApp(tester);
        await earnStars(5);
        await openParent(tester, '/parent/rewards');
        expect(
          find.text('אין עדיין פרסים. אפשר להוסיף פרס עם הכפתור למטה.'),
          findsOneWidget,
        );

        await tester.tap(find.text('הוספת פרס'));
        await settle(tester);
        await tester.enterText(
          find.widgetWithText(TextFormField, 'שם הפרס'),
          'גלידה',
        );
        for (var i = 0; i < 6; i++) {
          await tester.tap(find.byIcon(Icons.remove_rounded)); // 10 -> 4
          await tester.pump();
        }
        await tester.tap(find.text('שמירה'));
        await settle(tester);
        expect(find.text('גלידה'), findsOneWidget);
        expect(find.text('4 מתוך 4 ⭐'), findsOneWidget);

        // The child sees it on the celebration screen.
        container.read(parentSessionProvider.notifier).lock();
        container.read(routerProvider).go('/celebrate/morning');
        await settle(tester);
        expect(find.text('יש מספיק כוכבים לגלידה! 🎉'), findsOneWidget);

        await openParent(tester, '/parent/rewards');
        await tester.tap(find.widgetWithText(FilledButton, 'מימוש'));
        await settle(tester);
        expect(
          find.text('זה הרגע לעשות את זה ביחד! ירדו 4 כוכבים.'),
          findsOneWidget,
        );
        await tester.tap(
          find.descendant(
            of: find.byType(AlertDialog),
            matching: find.text('מימוש'),
          ),
        );
        await settle(tester);

        expect(container.read(starBalanceProvider).value, 1);
        expect(find.text('מומשו'), findsOneWidget);

        await tester.tap(find.text('להציע שוב'));
        await settle(tester);
        expect(find.text('גלידה'), findsNWidgets(2));
        expect(find.text('1 מתוך 4 ⭐'), findsOneWidget);
        // Not enough stars for the copy yet.
        final redeem = tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'מימוש'),
        );
        expect(redeem.onPressed, isNull);
      },
    );

    testWidgets('the celebration shows stars still needed', (tester) async {
      await pumpApp(tester);
      await earnStars(3);
      await container
          .read(rewardRepositoryProvider)
          .createReward(RewardsCompanion.insert(name: 'פארק', starCost: 8));
      container.read(routerProvider).go('/celebrate/morning');
      await settle(tester);
      expect(find.text('עוד 5 כוכבים לפארק!'), findsOneWidget);
    });
  });

  testWidgets('daily summary lists the day\'s tasks and stars', (tester) async {
    await pumpApp(tester);
    await earnStars(2);
    await openParent(tester, '/parent/summary');
    expect(find.text('היום'), findsOneWidget);
    expect(find.text('כוכבים שנאספו: 2'), findsOneWidget);
    expect(find.text('קימה מהמיטה'), findsOneWidget);
    expect(find.text('שירותים'), findsOneWidget);

    await tester.tap(find.byTooltip('יום קודם'));
    await settle(tester);
    expect(find.text('אין פעילות ביום הזה'), findsOneWidget);
  });

  testWidgets('settings change the child\'s name and gendered greeting', (
    tester,
  ) async {
    await pumpApp(tester);
    await openParent(tester, '/parent/settings');
    await tester.enterText(find.widgetWithText(TextField, 'שם הילד/ה'), 'נועה');
    await tester.tap(find.text('בן'));
    await tester.tap(find.text('שמירה'));
    await settle(tester);

    container.read(parentSessionProvider.notifier).lock();
    await settle(tester);
    expect(find.text('בוקר טוב, נועה!'), findsOneWidget);
    expect(find.text('בוא נתחיל!'), findsOneWidget);
  });
}

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
