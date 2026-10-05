# Release guide

## Build

```
flutter test
flutter analyze
flutter build appbundle --release   # build/app/outputs/bundle/release/app-release.aab  (upload to Play)
flutter build apk --release         # build/app/outputs/flutter-apk/app-release.apk     (sideload)
```

Before each new upload, raise the version in `pubspec.yaml`: `version: 1.0.1+2`
(the number after `+` must go up every time).

## Upload key — back it up

Release builds are signed with the **upload key**:

- Keystore: `%USERPROFILE%\.android-keys\kids_routine_upload.jks`
- Passwords and alias: `android/key.properties` (not in git)

Copy **both files** somewhere safe (a password manager or an encrypted drive). With
Play App Signing, Google keeps the real signing key; if the upload key is lost it can
be reset through Play Console support, but that takes days.

## First upload checklist (Play Console)

1. Create the app: default language Hebrew (`iw-IL`), app, free.
2. **Store listing**: texts in `store/listing.md`, icon `store/icon_512.png`.
   Still needed: a 1024×500 feature graphic and 2–8 phone screenshots (take them on
   the emulator or phone; `adb exec-out screencap -p > shot.png`).
3. **Privacy policy**: host `docs/privacy-policy.md` at a public URL (for example
   GitHub Pages) and fill in the contact email first.
4. **App access**: "All functionality is available without special access". Parent
   mode is behind a math question: hold the gear for 2 seconds, then answer.
5. **Ads**: No ads.
6. **Content rating** questionnaire: reference/education-style app, no violence, no
   user interaction, no data sharing → expected rating Everyone / PEGI 3.
7. **Target audience**: includes children under 13 (e.g. 5–8 and 9–12), plus parents.
   This puts the app under the **Families policy**; it complies: no ads, no
   analytics/SDKs, no data collection, no location, no internet permission.
8. **Data safety**: "No data collected" and "No data shared". Every data type: not
   collected (stays on device, never transmitted).
9. **Permissions** to explain if asked:
   - `RECORD_AUDIO` — parent records the task name in their own voice (parent mode only).
   - `POST_NOTIFICATIONS` — routine reminders the parent switches on.
   - `RECEIVE_BOOT_COMPLETED` — re-arm reminders after a restart.
   - `ACCESS_NETWORK_STATE` comes from the audio player library; without INTERNET the app cannot use the network.
   - `SCHEDULE_EXACT_ALARM` — reminders the parent sets for a routine's start time must
     arrive on time; the parent grants it in "Alarms & reminders". (Not `USE_EXACT_ALARM`.)
   - No camera permission (the camera opens through the system).
10. Upload `app-release.aab` to **Internal testing** first, install from the Play link
    on the family phone, then promote to Production.
