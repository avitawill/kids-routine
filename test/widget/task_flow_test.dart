import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/app.dart';
import 'package:kids_routine/state/providers.dart';
import 'package:kids_routine/ui/mascot/mascot.dart';
import 'package:kids_routine/ui/widgets/star_burst.dart';
import 'package:kids_routine/ui/widgets/star_counter.dart';

import '../helpers.dart';

void main() {
  late FakeAudio audio;
  late FakeClock clock;

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final db = makeTestDb();
    // Unmount first so no live query is left waiting when the DB closes.
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox());
      await db.close();
    });
    audio = FakeAudio();
    clock = FakeClock(DateTime(2026, 10, 5, 7, 0));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          mediaStoreProvider.overrideWithValue(makeTestMedia()),
          audioProvider.overrideWithValue(audio),
          clockProvider.overrideWithValue(clock.call),
        ],
        child: const KidsRoutineApp(),
      ),
    );
    await _settle(tester);
  }

  int starCount(WidgetTester tester) =>
      tester.widget<StarCounter>(find.byType(StarCounter)).count;

  MascotMood mascotMood(WidgetTester tester) =>
      tester.widget<Mascot>(find.byType(Mascot)).mood;

  testWidgets('Home → Task → Done gives a star and moves to the next task', (
    tester,
  ) async {
    await pumpApp(tester);

    // Home, in Hebrew, RTL.
    expect(find.text('בוקר טוב!'), findsOneWidget);
    expect(find.text('בואי נתחיל!'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('בוקר'))),
      TextDirection.rtl,
    );
    expect(find.text('0 מתוך 10'), findsOneWidget);

    await tester.tap(find.text('בוקר'));
    await _settle(tester);

    // First task, with a peek at the next one; announced with sound.
    expect(find.text('קימה מהמיטה'), findsOneWidget);
    expect(find.text('שירותים'), findsOneWidget);
    expect(audio.events, ['announce:wake_up']);
    expect(starCount(tester), 0);

    // Done: star sound + burst immediately, star in the counter.
    await tester.tap(find.text('סיימתי!'));
    await tester.pump();
    expect(audio.events.last, 'star');
    expect(find.byType(StarBurst), findsOneWidget);

    // An impatient second tap during the burst does nothing.
    await tester.tap(find.text('סיימתי!'));
    await _settle(tester);
    expect(starCount(tester), 1);
    expect(audio.events.where((e) => e == 'star'), hasLength(1));

    // After the burst (<= 1.5 s): next task, announced.
    await tester.pump(StarBurst.duration);
    await _settle(tester);
    expect(find.byType(StarBurst), findsNothing);
    expect(find.text('שירותים'), findsOneWidget);
    expect(find.text('קימה מהמיטה'), findsNothing);
    expect(find.text('צחצוח שיניים'), findsOneWidget); // next peek
    expect(audio.events.last, 'announce:toilet');
  });

  testWidgets(
    'time running out is gentle: chime, mascot waves, task stays open',
    (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('בוקר'));
      await _settle(tester);
      expect(mascotMood(tester), MascotMood.idle);

      // wake_up has a 2-minute target.
      clock.advance(const Duration(minutes: 2, seconds: 1));
      await _settle(tester);

      expect(audio.events, contains('timeUp'));
      expect(mascotMood(tester), MascotMood.wave);
      expect(find.text('קימה מהמיטה'), findsOneWidget);
      final done = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(done.onPressed, isNotNull);
    },
  );

  testWidgets(
    'finishing the last task shows the celebration with stars earned',
    (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('בוקר'));
      await _settle(tester);

      for (var i = 0; i < 10; i++) {
        await tester.tap(find.text('סיימתי!'));
        await _settle(tester);
        await tester.pump(StarBurst.duration);
        await _settle(tester);
      }

      expect(find.text('את אלופה!'), findsOneWidget);
      expect(find.text('סיימנו את שגרת הבוקר!'), findsOneWidget);
      expect(find.text('קיבלת 10 כוכבים!'), findsOneWidget);
      expect(audio.events.where((e) => e == 'star'), hasLength(10));

      // Back home: the card shows the routine as done.
      await tester.tap(find.text('חזרה הביתה'));
      await _settle(tester);
      expect(find.text('כל הכבוד! ✨'), findsOneWidget);
    },
  );
}

/// Lets DB futures and stream updates land. The task screen's ticker never
/// stops, so pumpAndSettle can't be used.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}
