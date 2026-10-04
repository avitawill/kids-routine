import '../../services/media_store.dart';

/// Tracks media files created while editing one record, so that unsaved or
/// replaced files are deleted instead of piling up in app storage.
class MediaDraft {
  MediaDraft(this.media, {String? photo, String? audio})
    : _originalPhoto = photo,
      _originalAudio = audio,
      photo = photo,
      audio = audio;

  final MediaStore media;
  final String? _originalPhoto;
  final String? _originalAudio;
  final _created = <String>{};

  String? photo;
  String? audio;

  bool get changed => photo != _originalPhoto || audio != _originalAudio;

  /// A new file now belongs to this draft.
  void adopt(String relativePath) => _created.add(relativePath);

  /// Replaces the photo; a file created earlier in this draft is deleted.
  void setPhoto(String? relativePath) {
    _dropIfCreated(photo);
    photo = relativePath;
  }

  void setAudio(String? relativePath) {
    _dropIfCreated(audio);
    audio = relativePath;
  }

  /// After saving: delete originals that were replaced.
  Future<void> commit() async {
    if (photo != _originalPhoto) await media.delete(_originalPhoto);
    if (audio != _originalAudio) await media.delete(_originalAudio);
    _created.clear();
  }

  /// After leaving without saving: delete everything this draft created.
  Future<void> discard() async {
    for (final f in _created) {
      await media.delete(f);
    }
    _created.clear();
  }

  void _dropIfCreated(String? path) {
    if (path != null && _created.remove(path)) media.delete(path);
  }
}
