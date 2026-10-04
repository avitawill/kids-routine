import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'services/media_store.dart';
import 'state/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Phones: portrait only. Tablets keep rotation (landscape layout in M4).
  final view = PlatformDispatcher.instance.views.first;
  final shortestSide = view.physicalSize.shortestSide / view.devicePixelRatio;
  if (shortestSide < 600) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  final media = await MediaStore.open();
  runApp(
    ProviderScope(
      overrides: [mediaStoreProvider.overrideWithValue(media)],
      child: const KidsRoutineApp(),
    ),
  );
}
