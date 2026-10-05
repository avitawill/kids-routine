# Kids Routine App

## What we're building
An Android app (phone + tablet) that walks a child through daily routines (morning, noon, evening) one task at a time: a picture, a visual countdown, a big "Done" button, and an immediate star. It's for my daughter, who takes a very long time to get ready. Design for kids who struggle with time awareness and transitions (ADHD-style).

Version 1.0 is being prepared for Google Play (kids / Families policy). Build and upload steps, the upload key and the Play Console answers are in `docs/release.md`; listing texts in `store/listing.md`; privacy policy in `docs/privacy-policy.md`.

## Hard constraints
- Flutter (latest stable), Android only for now. targetSdk 36. Handle edge-to-edge (SafeArea) and predictive back (PopScope).
- 100% offline. The release build must NOT declare the INTERNET permission. No analytics, crash reporting, ads, AD_ID, location, or any SDK that sends data anywhere.
- Camera and microphone are used only from parent mode. Photos and recordings stay in app storage.
- Languages: Hebrew (default, RTL), Spanish, English. Switching language works at runtime, no restart.
- The child-facing UI shows no digital clock and has no failure states.

## Stack
- State: flutter_riverpod
- DB: drift (SQLite) + build_runner
- Routing: go_router
- i18n: flutter_localizations + intl, ARB files, ICU `select` for gender
- Notifications: flutter_local_notifications. Exact alarms via the user-granted SCHEDULE_EXACT_ALARM (owner's decision, 2026-10-05: a 7:00 reminder must not arrive at 7:50); falls back to inexact if not granted. Never USE_EXACT_ALARM.
- Audio: just_audio (playback), record (parent recordings), flutter_tts (fallback voice)
- Images: image_picker
- Celebration: confetti package or hand-rolled; every animation <= 1.5 s
- Font: **Fredoka** (OFL), bundled in `assets/fonts/` as static 400/500/600/700 instances cut from the variable font. Chosen over Varela Round (single weight); both had full glyph coverage (א–ת, ׳ ״, ñ á é í ó ú ü ¡ ¿). Never fetch fonts at runtime.
- Approved extras: `drift_flutter` (SQLite native libs), `drift_dev` (codegen), `flutter_lints` (dev), `path_provider` (app documents folder), `timezone` (needed by flutter_local_notifications), `archive` (backup zip), `file_picker` (system save/open dialogs for backups; no permissions).
- Sounds: synthesized by `tool/make_sounds.py` into `assets/sounds/` (no third-party audio).

Ask me before adding any dependency not on this list.

## Behavior rules (research-backed; do not "improve" these away)
1. One task on screen at a time, with a big picture. Only a small peek at the next task. No long lists in child mode.
2. Visual timer: a colored pie that shrinks clockwise around the task picture. Never mirror it in RTL. When time runs out: gentle sound and the mascot waves. No red, no "late", the task stays open.
3. Immediate reward: tapping Done gives a star + short animation + sound + light haptic, instantly. Not only at the end of the routine.
4. Stars accumulate toward rewards the parent defines. Never take stars away, no streaks that break, no penalties.
5. Audio cue at routine start and on each move to the next task (the device reminds, not the parent).
6. The parent stays in the loop: a daily summary (what was done, how long each task and routine took), and reward redemption happens in parent mode, together with the child.

## Screens
- **Home**: three routine cards (morning/noon/evening) with progress; mascot greeting; small gear icon (parent entry).
- **Task**: emoji or photo, task name, shrinking pie timer, big Done button (most of the screen width, >= 64dp tall), next-task peek, replay-audio button.
- **Celebration**: end of routine; mascot cheers, stars earned, progress bar to the next reward.
- **Parent gate**: long-press the gear for 2 s, then a multiplication question (e.g. 7×8) with a number pad.
- **Parent mode**:
  - Routines: add/remove/reorder tasks, start time, days of week, reminder on/off.
  - Task editor: name in he/es/en, emoji or photo, record audio, target minutes.
  - Rewards: name, picture, star cost, redeem.
  - Daily summary.
  - Settings: child name, gender, app language, mascot name, Jewish pack on/off, backup export/import.
- **Layout**: tablet landscape = two panes on the Task screen (task + progress rail). Phone = single column, portrait.

## Data model (Drift)
- `Child(id, name, gender[female|male], language[he|es|en], mascotName)`
- `Routine(id, type[morning|noon|evening], startTime, daysOfWeek, reminderEnabled)`
- `Task(id, nameHe, nameEs, nameEn, emoji?, photoPath?, audioPath?, targetMinutes, pack[core|jewish|custom], isBuiltIn)`
- `RoutineTask(routineId, taskId, position)`
- `RunLog(id, date, routineId, taskId, startedAt, completedAt)`
- `Reward(id, name, photoPath?, starCost, redeemedAt?)`
- `StarLedger(id, date, delta, reason, refId)`: balance = sum(delta); only redemptions are negative.

Implementation notes (M1):
- `date` columns are local days as `yyyy-MM-dd` text. Routine `startTime` is stored as `startMinutes` (minutes after midnight); `daysOfWeek` is a bitmask (Monday = bit 0 … Sunday = bit 6).
- `Task.builtInKey` (e.g. `brush_teeth`) is a stable id for seeded tasks; null for custom ones. `RoutineTask` has its own `id`. Built-in tasks shared by routines (toothbrushing) are one Task row.
- A RunLog row is created when a task first appears (its timer starts then; unique per date/routine/task, so the timer survives restarts) and completed on Done. 1 star per task done; a task already done today awards nothing more; no bonus for finishing a routine.
- The release build strips INTERNET and AD_ID via `android/app/src/release/AndroidManifest.xml` (`tools:node="remove"`). The debug manifest keeps INTERNET for `flutter run`/hot reload.

Implementation notes (M2):
- Photos and recordings live under the app documents folder in `media/photos/` and `media/audio/`; the DB stores paths **relative** to that folder (`MediaStore`), so a backup can be restored on a new install. Photos are scaled to <= 1024 px. Unsaved or replaced media files are deleted (`MediaDraft`).
- Permissions: only RECORD_AUDIO (declared by `record`, requested on first tap of Record). Camera/gallery go through system intents (image_picker), so no CAMERA or storage permission.
- Parent gate: hold the gear 2 s (a ring fills), then a times-table question (factors 3–9) on an LTR number pad; a wrong answer shows a new question, no lockout. Parent mode stays unlocked until Exit or until the app is hidden; the camera/gallery/mic-permission round trip does not lock it.
- Rewards are one-time: redeeming stamps `redeemedAt` and adds one negative `redemption` ledger entry (only if balance >= cost). "Offer again" creates a fresh copy (with its own copy of the photo). The Celebration screen shows progress to the cheapest unredeemed reward.
- Settings (pulled into M2 with approval): child name, gender, mascot name. Language, Jewish pack, backup stay in M3/M4.
- Built-in tasks can be edited but not deleted (only removed from routines). Deleting a custom task also deletes its run history (cascade); stars already earned stay.
- Daily summary: per task, time from when it appeared on screen to Done, next to its target; per routine, start → finish. Neutral styling, no red. The reminder switch is stored only; notifications arrive in M3.
- Widget tests unmount the app before closing the test DB (otherwise a failing test hangs the runner). Prefer one-off `get…()` queries over `watch…().first` for single reads.

Implementation notes (M3):
- Schema v2: `Children.jewishPack`; the upgrade also fills Spanish/English names of built-in tasks where both are still empty (parent edits are kept). Covered by `test/data/migration_test.dart`.
- Reminders: `upcomingReminders` builds 14 days of local wall-clock times; `syncReminders` re-arms them (`exactAllowWhileIdle` when exact alarms are allowed, else `inexactAllowWhileIdle`; absolute UTC instants, no tz database) on launch, resume and any change to routines, language or gender. Tapping one opens that routine. The Android 13+ notification permission is asked when a reminder switch is turned on; refused → the switch stays off.
- Jewish pack placement rules live in `lib/domain/pack_placement.dart` (Modeh Ani first, Netilat Yadayim after it, Birchot Hashachar after getting dressed, the blessing before breakfast and lunch, Shema last in the evening); a missing anchor puts the task at the end. Turning the pack off removes those tasks from routines only.
- Spanish/English task names (for review) are in `lib/data/db/seed.dart` (`seedNamesEs`, `seedNamesEn`). The celebration line is a `select` on the routine type (Spanish needs different articles).
- Sessions are re-read on resume, so a routine left open overnight starts fresh.

Implementation notes (M4):
- Mascot moves: idle blink (every 4 s), wave (1.2 s, then rest), cheer (two hops in 1.2 s). Still when the system "remove animations" setting is on.
- Tablet landscape (>= 840 dp wide and wider than tall): task + progress rail. Phones: portrait only (set in `main.dart`).
- Accessibility: contrast pairs are asserted in `test/ui/contrast_test.dart` (AA). Every screen is tested at 200% text on a 360x640 phone in he/es/en; child screens cap text scaling at 1.5x (`childTextScaling`) because their type is already large. The pie timer has a screen-reader label with minutes left; nothing on screen shows a number.
- Backup = one .zip: `backup.json` (format `kids_routine_backup` v1, every table via drift `toJson`) + `media/...`. Restore parses and validates everything first, then replaces all tables in one transaction and the media folder; paths with `..` are ignored.
- Launcher icons and the 512 px Play icon are generated from `MascotPainter` by `flutter test tool/generate_icons_test.dart`. App name is localized (`res/values*/`): My Routine / השגרה שלי / Mi rutina.
- Release signing reads `android/key.properties` (not in git) → upload keystore in `%USERPROFILE%\.android-keys\`. Without it, release falls back to the debug key.
- The release APK's permissions: RECORD_AUDIO, POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED, SCHEDULE_EXACT_ALARM, VIBRATE, ACCESS_NETWORK_STATE (from the audio player library; harmless without INTERNET). No INTERNET.
- Widget tests: DB calls made directly from a test body must go through `tester.runAsync` (fresh drift queries don't complete on fake time); the `settle()` helpers do this.

Changes after first real use (2026-10-05, owner feedback):
- Any order: the child can tap the next-task peek, a progress dot, or a rail row to do that task now. The task she leaves is paused (its `startedAt` cleared) and its timer starts fresh when it comes back. After Done the app goes to the first not-done task; the peek always shows that one.
- Schema v3: `RunLogs.startedAt` is nullable (null = not running: paused or unchecked). Upgrade rebuilds the table, keeping rows.
- Parent corrections (daily summary, today only): tap a done task to uncheck it, or "restart today's routine". Stars are never taken away; a task that already earned its star today earns no second one when redone.
- Gear: the 2 s hold is timed by the clock (not animation frames, which lag at startup); a quick tap shows the hint "hold for parent mode" instead of doing nothing.

## Built-in task library (seed)
Task names are nouns, so they are gender-neutral ("צחצוח שיניים", not "תצחצחי"). Default minutes in parentheses. Fill Spanish and English names for every task and list them for my review.

- **Morning**: 🌅 קימה מהמיטה (2) · 🚽 שירותים (3) · 🪥 צחצוח שיניים (3) · 💦 שטיפת פנים (2) · 👕 התלבשות (7) · 💇 סירוק (3) · 🥣 ארוחת בוקר (15) · 🎒 הכנת תיק (3) · 👟 נעילת נעליים (3) · 🧥 מעיל (2)
- **Noon**: 🧼 רחיצת ידיים (2) · 🍽️ ארוחת צהריים (20) · 🎒 פריקת התיק (3) · 📚 שיעורי בית (20)
- **Evening**: 🧸 סידור צעצועים (5) · 🛁 מקלחת (10) · 🌙 פיג'מה (3) · 🪥 צחצוח שיניים (3) · 👗 הכנת בגדים למחר (5) · 📖 סיפור לפני השינה (10)
- **Jewish pack** (off by default; when turned on, insert at sensible positions; parent can reorder): מודה אני (1, first in morning) · נטילת ידיים (2, right after waking) · ברכות השחר (3) · ברכה לפני האוכל (1, before meals) · קריאת שמע על המיטה (3, last in evening)

## i18n
- One ARB file per locale. Task names live in the DB per language; fall back to Hebrew when missing.
- Gendered strings via ICU `select` on the child's gender (Hebrew: "בואי נתחיל" / "בוא נתחיל"; Spanish: "¡Lista!" / "¡Listo!").
- Directional layout only: `EdgeInsetsDirectional`, `AlignmentDirectional`. Mirror "next" arrows; never mirror the timer.
- When a task has no recorded audio, read its name with flutter_tts in the current language.

## Mascot
Original character only; nothing resembling an existing or known character. A simple, round, friendly animal drawn in code (CustomPainter) or as a simple asset, with three states: idle, cheer, wave. The child names it.

## Milestones — stop after each one, show me, and wait for my OK
(M1–M4 done; on 2026-10-05 the owner asked to run M3 and M4 through without stopping and prepare the Play release.)
- **M1 — Morning slice**: `flutter doctor` check; project setup; Drift schema + seed; Home → Task → Celebration for the morning routine only; pie timer; stars. i18n plumbing from day one, but only Hebrew strings filled. Runs on my phone via `flutter run`.
- **M2 — Parent mode**: gate, routine editor, custom task editor (photo + recording), rewards + redemption, daily summary.
- **M3 — Full day + languages**: noon/evening routines, reminders, Spanish/English, gendered strings, Jewish pack.
- **M4 — Polish**: mascot animations, tablet landscape layout, accessibility (WCAG AA contrast, system text scaling), backup export/import (JSON + media to a file I pick), signed release APK for sideloading.

## Working rules
- Plan before coding each milestone; list the files you'll touch.
- git from the first step; small commits with clear messages.
- Before reporting a milestone: `flutter analyze` is clean and tests pass (unit tests for the star ledger, routine progression and timer logic; a widget test for the Task → Done → next-task flow).
- Keep this file updated when a decision changes.
- Nothing outside the current milestone. If something seems needed, propose it instead of building it.
