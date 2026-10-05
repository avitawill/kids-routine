import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/app.dart';
import 'package:kids_routine/data/db/database.dart';
import 'package:kids_routine/router.dart';
import 'package:kids_routine/state/providers.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late FakeAudio audio;
  late FakeReminders reminders;
  late ProviderContainer container;

  Future<void> pumpApp(WidgetTester tester, DateTime now) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    db = makeTestDb();
    audio = FakeAudio();
    reminders = FakeReminders();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          mediaStoreProvider.overrideWithValue(makeTestMedia()),
          audioProvider.overrideWithValue(audio),
          recorderProvider.overrideWithValue(FakeRecorder()),
          remindersProvider.overrideWithValue(reminders),
          clockProvider.overrideWithValue(() => now),
        ],
        child: const KidsRoutineApp(),
      ),
    );
    container = ProviderScope.containerOf(
      tester.element(find.byType(KidsRoutineApp)),
    );
    addTearDown(() async {
      // Unmount before closing the DB so no stream is left waiting.
      await tester.pumpWidget(const SizedBox());
      await db.close();
    });
    await settle(tester);
  }

  testWidgets('noon and evening routines are playable', (tester) async {
    await pumpApp(tester, DateTime(2026, 10, 5, 13, 30));
    expect(find.text('צהריים טובים!'), findsOneWidget);
    expect(find.text('0 מתוך 4'), findsOneWidget); // noon
    expect(find.text('0 מתוך 6'), findsOneWidget); // evening

    await tester.tap(find.text('צהריים'));
    await settle(tester);
    expect(find.text('רחיצת ידיים'), findsOneWidget);
    expect(audio.events.last, 'announce:wash_hands');
  });

  testWidgets('switching to Spanish applies at once, gendered, with task '
      'names and the routine in Spanish', (tester) async {
    await pumpApp(tester, DateTime(2026, 10, 5, 7, 0));
    await tester.runAsync(
      () => container.read(repositoryProvider).setLanguage(AppLanguage.es),
    );
    await settle(tester);

    expect(find.text('¡Buenos días!'), findsOneWidget);
    expect(find.text('¿Lista? ¡Empecemos!'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('Mañana'))),
      TextDirection.ltr,
    );

    await tester.runAsync(
      () => container
          .read(repositoryProvider)
          .updateChild(name: 'Noa', gender: Gender.male, mascotName: 'Pomi'),
    );
    await settle(tester);
    expect(find.text('¡Buenos días, Noa!'), findsOneWidget);
    expect(find.text('¿Listo? ¡Empecemos!'), findsOneWidget);

    await tester.tap(find.text('Mañana'));
    await settle(tester);
    expect(find.text('Levantarse de la cama'), findsOneWidget);
    expect(find.text('¡Hecho!'), findsOneWidget);
  });

  testWidgets('English works too', (tester) async {
    await pumpApp(tester, DateTime(2026, 10, 5, 20, 0));
    await tester.runAsync(
      () => container.read(repositoryProvider).setLanguage(AppLanguage.en),
    );
    await settle(tester);
    expect(find.text('Good evening!'), findsOneWidget);
    await tester.tap(find.text('Evening'));
    await settle(tester);
    expect(find.text('Tidy up toys'), findsOneWidget);
  });

  testWidgets('turning a reminder on asks permission and schedules it in the '
      "child's language", (tester) async {
    await pumpApp(tester, DateTime(2026, 10, 5, 6, 0));
    expect(reminders.slots, isEmpty);

    container.read(parentSessionProvider.notifier).unlock();
    container.read(routerProvider).go('/parent/routine/morning');
    await settle(tester);
    await tester.tap(find.byType(Switch));
    await settle(tester);

    expect(reminders.slots, isNotEmpty);
    expect(reminders.slots.first.at, DateTime(2026, 10, 5, 7, 0));
    expect(
      reminders.texts!.title(RoutineType.morning),
      '🌅 הגיע הזמן לשגרת הבוקר',
    );
    expect(reminders.texts!.body, 'בואי נתחיל!');

    // Language change re-arms them in Spanish.
    await tester.runAsync(
      () => container.read(repositoryProvider).setLanguage(AppLanguage.es),
    );
    await settle(tester);
    expect(
      reminders.texts!.title(RoutineType.morning),
      '🌅 ¡Hora de la rutina de la mañana!',
    );
  });

  testWidgets('a refused permission leaves the reminder off', (tester) async {
    await pumpApp(tester, DateTime(2026, 10, 5, 6, 0));
    reminders.allowed = false;
    container.read(parentSessionProvider.notifier).unlock();
    container.read(routerProvider).go('/parent/routine/morning');
    await settle(tester);
    await tester.tap(find.byType(Switch));
    await settle(tester);
    expect(
      find.text('אין הרשאה להתראות. אפשר לאשר בהגדרות הטלפון.'),
      findsOneWidget,
    );
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    expect(reminders.slots, isEmpty);
  });

  testWidgets('tapping a reminder opens that routine', (tester) async {
    await pumpApp(tester, DateTime(2026, 10, 5, 19, 0));
    reminders.onOpen!(RoutineType.evening);
    await settle(tester);
    expect(find.text('סידור צעצועים'), findsOneWidget);
  });

  testWidgets('the Jewish pack switch in settings', (tester) async {
    await pumpApp(tester, DateTime(2026, 10, 5, 7, 0));
    container.read(parentSessionProvider.notifier).unlock();
    container.read(routerProvider).go('/parent/settings');
    await settle(tester);
    await tester.tap(find.text('מנהגים יהודיים'));
    await settle(tester);
    expect(container.read(childProvider).value!.jewishPack, isTrue);

    container.read(parentSessionProvider.notifier).lock();
    await settle(tester);
    expect(find.text('0 מתוך 14'), findsOneWidget);
    await tester.tap(find.text('בוקר'));
    await settle(tester);
    expect(find.text('מודה אני'), findsOneWidget);
  });
}

/// Pumps frames and lets real async work (fresh DB queries) finish.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.runAsync(
      () => Future.delayed(const Duration(milliseconds: 5)),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }
}
