import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

import '../data/db/database.dart';
import '../data/task_names.dart';

/// Every sound the child hears. Abstract so tests can swap in a silent fake.
abstract class AudioCues {
  /// Start-of-task cue followed by the task's recorded audio, or its name read
  /// aloud when there is no recording (behavior rule 5).
  Future<void> announceTask(Task task, AppLanguage lang);

  Future<void> playStar();
  Future<void> playTimeUp();
  Future<void> playCelebration();
  Future<void> stop();
  Future<void> dispose();
}

class AudioService implements AudioCues {
  final _effects = AudioPlayer();
  final _voice = AudioPlayer();
  final _tts = FlutterTts();
  int _generation = 0;

  static const _start = 'assets/sounds/start.wav';
  static const _star = 'assets/sounds/star.wav';
  static const _timeUp = 'assets/sounds/time_up.wav';

  @override
  Future<void> announceTask(Task task, AppLanguage lang) async {
    // A newer announcement (or stop) cancels the rest of this one.
    final gen = ++_generation;
    await _stopVoice();
    await _play(_effects, _start);
    if (gen != _generation) return;

    final audioPath = task.audioPath;
    if (audioPath != null && File(audioPath).existsSync()) {
      await _guard(() async {
        await _voice.setFilePath(audioPath);
        await _voice.play();
      });
    } else {
      await _speak(task.nameIn(lang), task.languageOfName(lang));
    }
  }

  @override
  Future<void> playStar() => _play(_effects, _star);

  @override
  Future<void> playTimeUp() => _play(_effects, _timeUp);

  @override
  Future<void> playCelebration() => _play(_effects, _star);

  @override
  Future<void> stop() async {
    _generation++;
    await _stopVoice();
    await _guard(_effects.stop);
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _effects.dispose();
    await _voice.dispose();
  }

  Future<void> _stopVoice() async {
    await _guard(_voice.stop);
    await _guard(_tts.stop);
  }

  Future<void> _play(AudioPlayer player, String asset) => _guard(() async {
    await player.setAsset(asset);
    await player.seek(Duration.zero);
    // play() completes when playback ends, so callers can sequence sounds.
    await player.play();
  });

  Future<void> _speak(String text, AppLanguage lang) => _guard(() async {
    final locale = switch (lang) {
      AppLanguage.he => 'he-IL',
      AppLanguage.es => 'es-ES',
      AppLanguage.en => 'en-US',
    };
    // No voice for this language on the device: stay quiet rather than read
    // Hebrew with an English voice.
    if (await _tts.isLanguageAvailable(locale) != true) return;
    await _tts.setLanguage(locale);
    await _tts.setSpeechRate(0.45);
    await _tts.awaitSpeakCompletion(true);
    await _tts.speak(text);
  });

  /// Sound is a nice-to-have: never let an audio error reach the child.
  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      debugPrint('audio: $e');
    }
  }
}
