# Kids Routine App

## What we're building
An Android app (phone + tablet) that walks a child through daily routines (morning, noon, evening) one task at a time: a picture, a visual countdown, a big "Done" button, and an immediate star. It's for my daughter, who takes a very long time to get ready. Design for kids who struggle with time awareness and transitions (ADHD-style).

Local-only for now: installed from my machine via `flutter run` / APK sideload. No Play Store yet, but stay Play-compliant (kids/Families policy) so publishing later is cheap.

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
- Notifications: flutter_local_notifications with inexact scheduling (do not request exact-alarm permission)
- Audio: just_audio (playback), record (parent recordings), flutter_tts (fallback voice)
- Images: image_picker
- Celebration: confetti package or hand-rolled; every animation <= 1.5 s
- Font: **Fredoka** (OFL), bundled in `assets/fonts/` as static 400/500/600/700 instances cut from the variable font. Chosen over Varela Round (single weight); both had full glyph coverage (א–ת, ׳ ״, ñ á é í ó ú ü ¡ ¿). Never fetch fonts at runtime.
- Approved extras: `drift_flutter` (SQLite native libs + path_provider), `drift_dev` (codegen), `flutter_lints` (dev).
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
