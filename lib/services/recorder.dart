import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';

/// Parent voice recordings. Abstract so tests don't touch the microphone.
abstract class VoiceRecorder {
  /// Starts recording to [absolutePath]. Returns false if the microphone
  /// permission was refused.
  Future<bool> start(String absolutePath);

  Future<void> stop();
  Future<void> dispose();
}

class MicVoiceRecorder implements VoiceRecorder {
  final _recorder = AudioRecorder();

  @override
  Future<bool> start(String absolutePath) async {
    if (!await _recorder.hasPermission()) return false;
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        numChannels: 1,
        bitRate: 96000,
      ),
      path: absolutePath,
    );
    return true;
  }

  @override
  Future<void> stop() async {
    await _recorder.stop();
  }

  @override
  Future<void> dispose() => _recorder.dispose();
}

/// Picks a photo from the camera or gallery, already scaled down. Returns the
/// picked file's (temporary) path, or null if cancelled.
typedef PhotoPicker = Future<String?> Function(ImageSource source);

Future<String?> pickPhoto(ImageSource source) async {
  final file = await ImagePicker().pickImage(
    source: source,
    maxWidth: 1024,
    maxHeight: 1024,
    imageQuality: 85,
  );
  return file?.path;
}
