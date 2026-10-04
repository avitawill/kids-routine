import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';

/// Photos and recordings live under the app's private documents folder. The
/// DB stores paths relative to it (e.g. `media/photos/…jpg`), so backups can
/// be restored on another install (M4).
class MediaStore {
  MediaStore(this.root);

  final Directory root;
  final _rng = Random();

  static Future<MediaStore> open() async =>
      MediaStore(await getApplicationDocumentsDirectory());

  File resolve(String relativePath) => File('${root.path}/$relativePath');

  /// The file for [relativePath] if it exists, else null.
  File? existing(String? relativePath) {
    if (relativePath == null) return null;
    final f = resolve(relativePath);
    return f.existsSync() ? f : null;
  }

  /// A fresh relative path, e.g. `media/audio/1730000000000_1234.m4a`.
  /// Creates the folder.
  String newPath(String kind, String extension) {
    Directory('${root.path}/media/$kind').createSync(recursive: true);
    final stamp = DateTime.now().millisecondsSinceEpoch;
    return 'media/$kind/${stamp}_${_rng.nextInt(1 << 20)}.$extension';
  }

  /// Copies an external file (e.g. from the photo picker) into app storage.
  Future<String> importPhoto(String sourcePath) async {
    final rel = newPath('photos', _extension(sourcePath, 'jpg'));
    await File(sourcePath).copy(resolve(rel).path);
    return rel;
  }

  /// Copies a stored file under a new name (so two records never share one).
  Future<String?> duplicate(String? relativePath) async {
    final src = existing(relativePath);
    if (src == null) return null;
    final parts = relativePath!.split('/');
    final kind = parts.length > 2 ? parts[1] : 'photos';
    final rel = newPath(kind, _extension(relativePath, 'bin'));
    await src.copy(resolve(rel).path);
    return rel;
  }

  Future<void> delete(String? relativePath) async {
    final f = existing(relativePath);
    if (f != null) await f.delete();
  }

  static String _extension(String path, String fallback) {
    final name = path.split(RegExp(r'[/\\]')).last;
    final dot = name.lastIndexOf('.');
    return dot > 0 && dot < name.length - 1
        ? name.substring(dot + 1).toLowerCase()
        : fallback;
  }
}
